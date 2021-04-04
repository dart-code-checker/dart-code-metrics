// ignore_for_file: long-method, comment_references
import 'dart:io';
import 'dart:math';

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:glob/glob.dart';
import 'package:path/path.dart' as p;
import 'package:file/local.dart';

import '../metrics/cyclomatic_complexity/cyclomatic_complexity_metric.dart';
import '../metrics/maximum_nesting_level/maximum_nesting_level_metric.dart';
import '../metrics/number_of_methods_metric.dart';
import '../metrics/number_of_parameters_metric.dart';
import '../metrics/weight_of_class_metric.dart';
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
import 'config/analysis_options.dart' as metrics;
import 'config/config.dart' as metrics;
import 'config/config.dart';
import 'halstead_volume/halstead_volume_ast_visitor.dart';
import 'metrics/lines_of_executable_code/lines_of_executable_code_visitor.dart';
import 'metrics_records_store.dart';
import 'models/function_record.dart';
import 'models/internal_resolved_unit_result.dart';
import 'reporters/utility_selector.dart';
import 'rules_factory.dart';

// ignore: deprecated_member_use
final _featureSet = FeatureSet.fromEnableFlags([]);

/// Performs code quality analysis on specified files
/// See [MetricsAnalysisRunner] to get analysis info
class MetricsAnalyzer {
  final Iterable<Rule> _checkingCodeRules;
  final Iterable<BasePattern> _checkingAntiPatterns;
  final Iterable<Glob> _globalExclude;
  final metrics.Config _metricsConfig;
  final Iterable<Glob> _metricsExclude;
  final MetricsRecordsStore _store;
  final bool _useFastParser;

  MetricsAnalyzer(
    this._store, {
    metrics.AnalysisOptions? options,
    Iterable<String> additionalExcludes = const [],
  })  : _checkingCodeRules =
            options?.rules != null ? getRulesById(options!.rules) : [],
        _checkingAntiPatterns = options?.antiPatterns != null
            ? getPatternsById(options!.antiPatterns)
            : [],
        _globalExclude = [
          ..._prepareExcludes(options?.excludePatterns),
          ..._prepareExcludes(additionalExcludes),
        ],
        _metricsConfig = options?.metricsConfig ?? const metrics.Config(),
        _metricsExclude = _prepareExcludes(options?.excludeForMetricsPatterns),
        _useFastParser = true;

  /// Return a future that will complete after static analysis done for files from [folders].
  Future<void>? runAnalysis(Iterable<String> folders, String rootFolder) async {
    AnalysisContextCollection? collection;
    if (!_useFastParser) {
      collection = AnalysisContextCollection(
        includedPaths: folders
            .map((path) => p.normalize(p.join(rootFolder, path)))
            .toList(),
        resourceProvider: PhysicalResourceProvider.INSTANCE,
      );
    }

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

      InternalResolvedUnitResult source;
      if (_useFastParser) {
        final result = parseFile(
          path: normalized,
          featureSet: _featureSet,
          throwIfDiagnostics: false,
        );

        source = InternalResolvedUnitResult(
          Uri.parse(filePath),
          result.content,
          result.unit,
        );
      } else {
        final analysisContext = collection!.contextFor(normalized);
        final result =
            await analysisContext.currentSession.getResolvedUnit(normalized);

        source = InternalResolvedUnitResult(
          Uri.parse(filePath),
          result.content!,
          result.unit!,
        );
      }

      final visitor = ScopeVisitor();
      source.unit.visitChildren(visitor);

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

      final lineInfo = source.unit.lineInfo!;

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
                  source: source,
                ),
                metrics: [
                  NumberOfMethodsMetric(config: {
                    NumberOfMethodsMetric.metricId:
                        '${_metricsConfig.numberOfMethodsWarningLevel}',
                  }).compute(
                    classDeclaration.declaration,
                    visitor.classes,
                    functions,
                    source,
                  ),
                  WeightOfClassMetric(config: {
                    WeightOfClassMetric.metricId:
                        '${_metricsConfig.weightOfClassWarningLevel}',
                  }).compute(
                    classDeclaration.declaration,
                    visitor.classes,
                    visitor.functions,
                    source,
                  ),
                ],
              ),
            );
          }

          for (final function in functions) {
            final cyclomatic = CyclomaticComplexityMetric(config: {
              CyclomaticComplexityMetric.metricId:
                  '${_metricsConfig.cyclomaticComplexityWarningLevel}',
            }).compute(
              function.declaration,
              visitor.classes,
              visitor.functions,
              source,
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
                _metricsConfig.linesOfExecutableCodeWarningLevel,
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
              FunctionRecord(
                location: nodeLocation(
                  node: function.declaration,
                  source: source,
                ),
                metrics: [
                  cyclomatic,
                  MetricValue<double>(
                    metricsId: '',
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
                  MaximumNestingLevelMetric(config: {
                    MaximumNestingLevelMetric.metricId:
                        '${_metricsConfig.maximumNestingWarningLevel}',
                  }).compute(
                    function.declaration,
                    visitor.classes,
                    visitor.functions,
                    source,
                  ),
                  NumberOfParametersMetric(config: {
                    NumberOfParametersMetric.metricId:
                        '${_metricsConfig.numberOfParametersWarningLevel}',
                  }).compute(
                    function.declaration,
                    visitor.classes,
                    visitor.functions,
                    source,
                  ),
                  linesOfExecutableCode,
                ],
              ),
            );
          }
        }

        final ignores = Suppression(source.content, lineInfo);

        builder
          ..recordIssues(_checkOnCodeIssues(ignores, source))
          ..recordAntiPatternCases(
            _checkOnAntiPatterns(ignores, source, functions),
          );
      });
    }
  }

  Iterable<Issue> _checkOnCodeIssues(
    Suppression ignores,
    InternalResolvedUnitResult source,
  ) =>
      _checkingCodeRules.where((rule) => !ignores.isSuppressed(rule.id)).expand(
            (rule) => rule.check(source).where((issue) => !ignores
                .isSuppressedAt(issue.ruleId, issue.location.start.line)),
          );

  Iterable<Issue> _checkOnAntiPatterns(
    Suppression ignores,
    InternalResolvedUnitResult source,
    Iterable<ScopedFunctionDeclaration> functions,
  ) =>
      _checkingAntiPatterns
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
