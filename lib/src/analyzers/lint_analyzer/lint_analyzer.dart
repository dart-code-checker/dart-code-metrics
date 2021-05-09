import 'dart:io';
import 'dart:math';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:file/local.dart';
import 'package:glob/glob.dart';
import 'package:path/path.dart';

import '../../../metrics_analyzer.dart';
import '../../utils/exclude_utils.dart';
import '../../utils/node_utils.dart';
import '../models/entity_type.dart';
import '../models/file_report.dart';
import '../models/internal_resolved_unit_result.dart';
import '../models/issue.dart';
import '../models/report.dart';
import '../models/scoped_class_declaration.dart';
import '../models/scoped_function_declaration.dart';
import '../models/suppression.dart';
import 'anti_patterns/patterns_factory.dart';
import 'metrics/halstead_volume_ast_visitor.dart';
import 'metrics/metric_utils.dart';
import 'metrics/metrics_factory.dart';
import 'metrics/metrics_list/cyclomatic_complexity/cyclomatic_complexity_metric.dart';
import 'metrics/metrics_list/source_lines_of_code/source_code_visitor.dart';
import 'metrics/models/metric_documentation.dart';
import 'metrics/models/metric_value.dart';
import 'metrics/models/metric_value_level.dart';
import 'parserd_config.dart';
import 'reporters/utility_selector.dart';
import 'rules/rules_factory.dart';
import 'scope_visitor.dart';

class LintAnalyzer {
  const LintAnalyzer();

  FileReport? runPluginAnalysis(
    ResolvedUnitResult result,
    ParsedConfig config,
    String rootFolder,
  ) {
    if (!isExcluded(result.path, config.globalExcludes)) {
      return _runAnalysisForFile(
        result,
        config,
        rootFolder,
        filePath: result.path,
      );
    }

    return null;
  }

  Future<Iterable<FileReport>> runCliAnalysis(
    Iterable<String> folders,
    String rootFolder,
    Config config,
  ) async {
    final parsedConfig = _parseConfig(config, rootFolder);
    final collection = AnalysisContextCollection(
      includedPaths:
          folders.map((path) => normalize(join(rootFolder, path))).toList(),
      resourceProvider: PhysicalResourceProvider.INSTANCE,
    );

    final filePaths = folders
        .expand((directory) => Glob('$directory/**.dart')
            .listFileSystemSync(
              const LocalFileSystem(),
              root: rootFolder,
              followLinks: false,
            )
            .whereType<File>()
            .where((entity) => !isExcluded(
                  relative(entity.path, from: rootFolder),
                  parsedConfig.globalExcludes,
                ))
            .map((entity) => entity.path))
        .toList();

    final analyzerResult = <FileReport>[];

    for (final filePath in filePaths) {
      final normalized = normalize(absolute(filePath));

      final analysisContext = collection.contextFor(normalized);
      final unit =
          // ignore: deprecated_member_use
          await analysisContext.currentSession.getResolvedUnit(normalized);
      final result = _runAnalysisForFile(
        unit,
        parsedConfig,
        rootFolder,
        filePath: filePath,
      );

      if (result != null) {
        analyzerResult.add(result);
      }
    }

    return analyzerResult;
  }

  FileReport? _runAnalysisForFile(
    ResolvedUnitResult result,
    ParsedConfig config,
    String rootFolder, {
    String? filePath,
  }) {
    final unit = result.unit;
    final content = result.content;

    if (unit != null &&
        content != null &&
        result.state == ResultState.VALID &&
        filePath != null &&
        _isSupported(result)) {
      final ignores = Suppression(content, result.lineInfo);
      final internalResult = InternalResolvedUnitResult(
        result.uri,
        content,
        unit,
        result.lineInfo,
      );
      final relativePath = relative(filePath, from: rootFolder);

      final issues = _checkOnCodeIssues(
        ignores,
        internalResult,
        config,
        filePath,
        rootFolder,
      );

      if (!isExcluded(filePath, config.metricsExcludes)) {
        final visitor = ScopeVisitor();
        internalResult.unit.visitChildren(visitor);

        final functions = visitor.functions.where((function) {
          final declaration = function.declaration;
          if (declaration is ConstructorDeclaration &&
              declaration.body is EmptyFunctionBody) {
            return false;
          } else if (declaration is MethodDeclaration &&
              declaration.body is EmptyFunctionBody) {
            return false;
          }

          return true;
        }).toList();

        final antiPatterns = _checkOnAntiPatterns(
          ignores,
          internalResult,
          functions,
          config,
        );

        final classMetrics = _checkClassMetrics(
          visitor,
          internalResult,
          config,
        );

        final functionMetrics = _checkFunctionMetrics(
          visitor,
          internalResult,
          config,
        );

        return FileReport(
          path: filePath,
          relativePath: relativePath,
          classes: Map.unmodifiable(classMetrics
              .map<String, Report>((key, value) => MapEntry(key.name, value))),
          functions: Map.unmodifiable(functionMetrics.map<String, Report>(
            (key, value) => MapEntry(key.fullName, value),
          )),
          issues: issues,
          antiPatternCases: antiPatterns,
        );
      }

      return FileReport(
        path: filePath,
        relativePath: relativePath,
        classes: const {},
        functions: const {},
        issues: issues,
        antiPatternCases: const [],
      );
    }

    return null;
  }

  Iterable<Issue> _checkOnCodeIssues(
    Suppression ignores,
    InternalResolvedUnitResult source,
    ParsedConfig config,
    String filePath,
    String? rootFolder,
  ) =>
      config.codeRules
          .where((rule) =>
              !ignores.isSuppressed(rule.id) &&
              (rootFolder == null ||
                  !isExcluded(
                    filePath,
                    prepareExcludes(rule.excludes, rootFolder),
                  )))
          .expand(
            (rule) =>
                rule.check(source).where((issue) => !ignores.isSuppressedAt(
                      issue.ruleId,
                      issue.location.start.line,
                    )),
          )
          .toList();

  Iterable<Issue> _checkOnAntiPatterns(
    Suppression ignores,
    InternalResolvedUnitResult source,
    Iterable<ScopedFunctionDeclaration> functions,
    ParsedConfig config,
  ) =>
      config.antiPatterns
          .where((pattern) => !ignores.isSuppressed(pattern.id))
          .expand((pattern) => pattern
              .legacyCheck(source, functions, config.metricsConfig)
              .where((issue) => !ignores.isSuppressedAt(
                    issue.ruleId,
                    issue.location.start.line,
                  )))
          .toList();

  Map<ScopedClassDeclaration, Report> _checkClassMetrics(
    ScopeVisitor visitor,
    InternalResolvedUnitResult source,
    ParsedConfig config,
  ) {
    final classRecords = <ScopedClassDeclaration, Report>{};

    for (final classDeclaration in visitor.classes) {
      final report = Report(
        location: nodeLocation(
          node: classDeclaration.declaration,
          source: source,
        ),
        declaration: classDeclaration.declaration,
        metrics: [
          for (final metric in config.classesMetrics)
            if (metric.supports(
              classDeclaration.declaration,
              visitor.classes,
              visitor.functions,
              source,
            ))
              metric.compute(
                classDeclaration.declaration,
                visitor.classes,
                visitor.functions,
                source,
              ),
        ],
      );

      classRecords[classDeclaration] = report;
    }

    return classRecords;
  }

  Map<ScopedFunctionDeclaration, Report> _checkFunctionMetrics(
    ScopeVisitor visitor,
    InternalResolvedUnitResult source,
    ParsedConfig config,
  ) {
    final functionRecords = <ScopedFunctionDeclaration, Report>{};

    for (final function in visitor.functions) {
      final cyclomatic = config.methodsMetrics
          .firstWhere(
            (metric) => metric.id == CyclomaticComplexityMetric.metricId,
          )
          .compute(
            function.declaration,
            visitor.classes,
            visitor.functions,
            source,
          );

      final linesOfExecutableCodeVisitor = SourceCodeVisitor(source.lineInfo);

      function.declaration.visitChildren(linesOfExecutableCodeVisitor);

      final linesOfExecutableCode = MetricValue<int>(
        metricsId: linesOfExecutableCodeKey,
        documentation: const MetricDocumentation(
          name: '',
          shortName: '',
          brief: '',
          measuredType: EntityType.methodEntity,
          examples: [],
        ),
        value: linesOfExecutableCodeVisitor.linesWithCode.length,
        level: valueLevel(
          linesOfExecutableCodeVisitor.linesWithCode.length,
          readThreshold<int>(
            config.metricsConfig,
            linesOfExecutableCodeKey,
            linesOfExecutableCodeDefaultWarningLevel,
          ),
        ),
        comment: '',
      );

      final halsteadVolumeAstVisitor = HalsteadVolumeAstVisitor();

      function.declaration.visitChildren(halsteadVolumeAstVisitor);

      // Total number of occurrences of operators.
      final totalNumberOfOccurrencesOfOperators =
          sum(halsteadVolumeAstVisitor.operators.values);

      // Total number of occurrences of operands
      final totalNumberOfOccurrencesOfOperands =
          sum(halsteadVolumeAstVisitor.operands.values);

      // Number of distinct operators.
      final numberOfDistinctOperators =
          halsteadVolumeAstVisitor.operators.keys.length;

      // Number of distinct operands.
      final numberOfDistinctOperands =
          halsteadVolumeAstVisitor.operands.keys.length;

      // Halstead Program Length – The total number of operator occurrences and the total number of operand occurrences.
      final halsteadProgramLength = totalNumberOfOccurrencesOfOperators +
          totalNumberOfOccurrencesOfOperands;

      // Halstead Vocabulary – The total number of unique operator and unique operand occurrences.
      final halsteadVocabulary =
          numberOfDistinctOperators + numberOfDistinctOperands;

      // Program Volume – Proportional to program size, represents the size, in bits, of space necessary for storing the program. This parameter is dependent on specific algorithm implementation.
      final halsteadVolume =
          halsteadProgramLength * log2(max(1, halsteadVocabulary));

      final maintainabilityIndex = max(
        0,
        (171 -
                5.2 * log(max(1, halsteadVolume)) -
                cyclomatic.value * 0.23 -
                16.2 * log(max(1, linesOfExecutableCode.value))) *
            100 /
            171,
      ).toDouble();

      final report = Report(
        location: nodeLocation(
          node: function.declaration,
          source: source,
        ),
        declaration: function.declaration,
        metrics: [
          for (final metric in config.methodsMetrics)
            if (metric.supports(
              function.declaration,
              visitor.classes,
              visitor.functions,
              source,
            ))
              metric.compute(
                function.declaration,
                visitor.classes,
                visitor.functions,
                source,
              ),
          MetricValue<double>(
            metricsId: 'maintainability-index',
            documentation: const MetricDocumentation(
              name: '',
              shortName: '',
              brief: '',
              measuredType: EntityType.classEntity,
              examples: [],
            ),
            value: maintainabilityIndex,
            level: _maintainabilityIndexViolationLevel(
              maintainabilityIndex,
            ),
            comment: '',
          ),
          if (config.metricsConfig.containsKey(linesOfExecutableCodeKey))
            linesOfExecutableCode,
        ],
      );

      functionRecords[function] = report;
    }

    return functionRecords;
  }

  ParsedConfig _parseConfig(Config config, String root) => ParsedConfig(
        prepareExcludes(config.excludePatterns, root),
        getRulesById(config.rules),
        getPatternsById(config.antiPatterns),
        metrics(
          config: config.metrics,
          measuredType: EntityType.classEntity,
        ),
        metrics(
          config: config.metrics,
          measuredType: EntityType.methodEntity,
        ),
        prepareExcludes(config.excludeForMetricsPatterns, root),
        config.metrics,
      );

  MetricValueLevel _maintainabilityIndexViolationLevel(double index) {
    if (index < 10) {
      return MetricValueLevel.alarm;
    } else if (index < 20) {
      return MetricValueLevel.warning;
    } else if (index < 40) {
      return MetricValueLevel.noted;
    }

    return MetricValueLevel.none;
  }

  bool _isSupported(AnalysisResult result) =>
      result.path != null &&
      result.path!.endsWith('.dart') &&
      !result.path!.endsWith('.g.dart');
}
