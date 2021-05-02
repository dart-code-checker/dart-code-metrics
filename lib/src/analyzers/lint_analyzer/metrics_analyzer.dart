// ignore_for_file: long-method, comment_references
import 'dart:io';
import 'dart:math';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:file/local.dart';
import 'package:glob/glob.dart';
import 'package:path/path.dart' as p;

import '../../analyzer_plugin/plugin_utils.dart';
import '../../config_builder/models/config.dart';
import '../../utils/node_utils.dart';
import '../models/internal_resolved_unit_result.dart';
import '../models/issue.dart';
import '../models/report.dart';
import '../models/scoped_function_declaration.dart';
import '../models/suppression.dart';
import 'anti_patterns/anti_patterns_factory.dart';
import 'anti_patterns/models/obsolete_pattern.dart';
import 'constants.dart';
import 'metrics/halstead_volume_ast_visitor.dart';
import 'metrics/metric_utils.dart';
import 'metrics/metrics_factory.dart';
import 'metrics/metrics_list/cyclomatic_complexity/cyclomatic_complexity_metric.dart';
import 'metrics/metrics_list/source_lines_of_code/source_code_visitor.dart';
import 'metrics/models/entity_type.dart';
import 'metrics/models/metric.dart';
import 'metrics/models/metric_documentation.dart';
import 'metrics/models/metric_value.dart';
import 'metrics/models/metric_value_level.dart';
import 'metrics_records_store.dart';
import 'reporters/utility_selector.dart';
import 'rules/models/rule.dart';
import 'rules/rules_factory.dart';
import 'scope_visitor.dart';

/// Performs code quality analysis on specified files
/// See [MetricsAnalysisRunner] to get analysis info
class MetricsAnalyzer {
  final Iterable<Glob> _globalExclude;
  final Iterable<Rule> _codeRules;
  final Iterable<ObsoletePattern> _antiPatterns;
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
          // ignore: deprecated_member_use
          await analysisContext.currentSession.getResolvedUnit(normalized);

      final unit = result.unit;
      final content = result.content;

      if (unit == null ||
          content == null ||
          result.state != ResultState.VALID) {
        continue;
      }

      final internalResult = InternalResolvedUnitResult(
        result.uri,
        content,
        unit,
        result.lineInfo,
      );

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

      final lineInfo = internalResult.lineInfo;

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
                  source: internalResult,
                ),
                metrics: [
                  for (final metric in _classesMetrics)
                    if (metric.supports(
                      classDeclaration.declaration,
                      visitor.classes,
                      visitor.functions,
                      internalResult,
                    ))
                      metric.compute(
                        classDeclaration.declaration,
                        visitor.classes,
                        visitor.functions,
                        internalResult,
                      ),
                ],
              ),
            );
          }

          for (final function in functions) {
            final cyclomatic = _methodsMetrics
                .firstWhere(
                  (metric) => metric.id == CyclomaticComplexityMetric.metricId,
                )
                .compute(
                  function.declaration,
                  visitor.classes,
                  visitor.functions,
                  internalResult,
                );

            final linesOfExecutableCodeVisitor = SourceCodeVisitor(lineInfo);

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
                  source: internalResult,
                ),
                metrics: [
                  for (final metric in _methodsMetrics)
                    if (metric.supports(
                      function.declaration,
                      visitor.classes,
                      visitor.functions,
                      internalResult,
                    ))
                      metric.compute(
                        function.declaration,
                        visitor.classes,
                        visitor.functions,
                        internalResult,
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

        final ignores = Suppression(internalResult.content, lineInfo);

        builder.recordIssues(_checkOnCodeIssues(
          ignores,
          internalResult,
          filePath,
          rootFolder,
        ));

        if (!_isExcluded(
          p.relative(filePath, from: rootFolder),
          _metricsExclude,
        )) {
          builder.recordAntiPatternCases(
            _checkOnAntiPatterns(ignores, internalResult, functions),
          );
        }
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
                prepareExcludes(rule.excludes, rootFolder),
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
              .legacyCheck(source, functions, _metricsConfig)
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
