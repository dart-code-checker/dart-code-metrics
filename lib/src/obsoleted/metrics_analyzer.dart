// ignore_for_file: long-method, comment_references
import 'dart:io';
import 'dart:math';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:analyzer/source/line_info.dart';
import 'package:file/local.dart';
import 'package:glob/glob.dart';
import 'package:path/path.dart' as p;

import '../config/config.dart';
import '../metrics/cyclomatic_complexity/cyclomatic_complexity_metric.dart';
import '../metrics/metric.dart';
import '../metrics_factory.dart';
import '../models/entity_type.dart';
import '../models/issue.dart';
import '../models/metric_documentation.dart';
import '../models/metric_value.dart';
import '../models/metric_value_level.dart';
import '../models/report.dart';
import '../models/scoped_function_declaration.dart';
import '../rules/rule.dart';
import '../scope_visitor.dart';
import '../suppression.dart';
import '../utils/metric_utils.dart';
import '../utils/node_utils.dart';
import 'anti_patterns/base_pattern.dart';
import 'anti_patterns_factory.dart';
import 'constants.dart';
import 'halstead_volume/halstead_volume_ast_visitor.dart';
import 'metrics/lines_of_executable_code/lines_of_executable_code_visitor.dart';
import 'metrics_records_store.dart';
import 'models/internal_resolved_unit_result.dart';
import 'reporters/utility_selector.dart';
import 'rules_factory.dart';

/// Performs code quality analysis on specified files
/// See [MetricsAnalysisRunner] to get analysis info
class MetricsAnalyzer {
  final Iterable<Glob> _globalExclude;
  final Iterable<Rule> _codeRules;
  final Iterable<BasePattern> _antiPatterns;
  final Iterable<Metric> _classesMetrics;
  final Iterable<Metric> _methodsMetrics;
  final Iterable<Glob> _metricsExclude;
  final Map<String, Object> _metricsConfig;
  final MetricsRecordsStore _store;

  MetricsAnalyzer(this._store, Config config)
      : _globalExclude = _prepareExcludes(config.excludePatterns),
        _codeRules = getRulesById(config.rules),
        _antiPatterns = getPatternsById(config.antiPatterns),
        _classesMetrics = metrics(
          config: config.metrics,
          measuredType: EntityType.classEntity,
        ),
        _methodsMetrics = metrics(
          config: config.metrics,
          measuredType: EntityType.methodEntity,
        ),
        _metricsExclude = _prepareExcludes(config.excludeForMetricsPatterns),
        _metricsConfig = config.metrics;

  /// Return a future that will complete after static analysis done for files from [folders].
  Future<void> runAnalysis(Iterable<String> folders, String rootFolder) async {
    final collection = AnalysisContextCollection(
      includedPaths:
          folders.map((path) => p.normalize(p.join(rootFolder, path))).toList(),
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
            .where((entity) => !_isExcluded(
                  p.relative(entity.path, from: rootFolder),
                  _globalExclude,
                ))
            .map((entity) => entity.path))
        .toList();

    for (final filePath in filePaths) {
      final normalized = p.normalize(p.absolute(filePath));

      final analysisContext = collection.contextFor(normalized);
      final result =
          await analysisContext.currentSession.getResolvedUnit(normalized);

      final visitor = ScopeVisitor();
      result.unit?.visitChildren(visitor);

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

      final lineInfo = result.unit?.lineInfo ?? LineInfo([]);

      _store.recordFile(filePath, rootFolder, (builder) {
        if (!_isExcluded(
          p.relative(filePath, from: rootFolder),
          _metricsExclude,
        )) {
          for (final classDeclaration in visitor.classes) {
            builder.recordClass(
              classDeclaration,
              Report(
                location: nodeLocation(
                  node: classDeclaration.declaration,
                  source: result,
                ),
                metrics: [
                  for (final metric in _classesMetrics)
                    if (metric.supports(
                      classDeclaration.declaration,
                      visitor.classes,
                      visitor.functions,
                      result,
                    ))
                      metric.compute(
                        classDeclaration.declaration,
                        visitor.classes,
                        visitor.functions,
                        result,
                      ),
                ],
              ),
            );
          }

          for (final function in functions) {
            final cyclomatic = _methodsMetrics
                .firstWhere((metric) =>
                    metric.id == CyclomaticComplexityMetric.metricId)
                .compute(
                  function.declaration,
                  visitor.classes,
                  visitor.functions,
                  result,
                );

            final linesOfExecutableCodeVisitor =
                LinesOfExecutableCodeVisitor(lineInfo);

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
                  _metricsConfig,
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

            builder.recordFunctionData(
              function,
              Report(
                location: nodeLocation(
                  node: function.declaration,
                  source: result,
                ),
                metrics: [
                  for (final metric in _methodsMetrics)
                    if (metric.supports(
                      function.declaration,
                      visitor.classes,
                      visitor.functions,
                      result,
                    ))
                      metric.compute(
                        function.declaration,
                        visitor.classes,
                        visitor.functions,
                        result,
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
                  linesOfExecutableCode,
                ],
              ),
            );
          }
        }

        final ignores = Suppression(result.content ?? '', lineInfo);

        final source = InternalResolvedUnitResult(
          Uri.parse(filePath),
          result.content!,
          result.unit!,
        );

        builder
          ..recordIssues(_checkOnCodeIssues(
            ignores,
            source,
            filePath,
            rootFolder,
          ))
          ..recordAntiPatternCases(
            _checkOnAntiPatterns(ignores, source, functions),
          );
      });
    }
  }

  Iterable<Issue> _checkOnCodeIssues(
    Suppression ignores,
    InternalResolvedUnitResult source,
    String filePath,
    String rootFolder,
  ) =>
      _codeRules
          .where((rule) =>
              !ignores.isSuppressed(rule.id) &&
              !_isExcluded(
                p.relative(filePath, from: rootFolder),
                _metricsExclude,
              ))
          .expand(
            (rule) => rule.check(source).where((issue) => !ignores
                .isSuppressedAt(issue.ruleId, issue.location.start.line)),
          );

  Iterable<Issue> _checkOnAntiPatterns(
    Suppression ignores,
    InternalResolvedUnitResult source,
    Iterable<ScopedFunctionDeclaration> functions,
  ) =>
      _antiPatterns
          .where((pattern) => !ignores.isSuppressed(pattern.id))
          .expand((pattern) => pattern
              .check(source, functions, _metricsConfig)
              .where((issue) => !ignores.isSuppressedAt(
                    issue.ruleId,
                    issue.location.start.line,
                  )));
}

Iterable<Glob> _prepareExcludes(Iterable<String>? patterns) =>
    patterns?.map((exclude) => Glob(exclude)).toList() ?? [];

bool _isExcluded(String filePath, Iterable<Glob> excludes) =>
    excludes.any((exclude) => exclude.matches(filePath));

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
