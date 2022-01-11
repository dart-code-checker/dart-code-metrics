// ignore_for_file: public_member_api_docs

import '../../../../utils/node_utils.dart';
import '../../lint_utils.dart';
import '../../metrics/metric_utils.dart';
import '../../metrics/metrics_list/number_of_parameters_metric.dart';
import '../../metrics/models/metric_value_level.dart';
import '../../models/entity_type.dart';
import '../../models/function_type.dart';
import '../../models/internal_resolved_unit_result.dart';
import '../../models/issue.dart';
import '../../models/report.dart';
import '../../models/scoped_class_declaration.dart';
import '../../models/scoped_function_declaration.dart';
import '../../models/severity.dart';
import '../models/pattern.dart';
import '../pattern_utils.dart';

class LongParameterList extends Pattern {
  static const String patternId = 'long-parameter-list';

  final int? _numberOfParametersMetricTreshold;

  @override
  Iterable<String> get dependentMetricIds =>
      [NumberOfParametersMetric.metricId];

  LongParameterList({
    Map<String, Object> patternSettings = const {},
    Map<String, Object> metricstTresholds = const {},
  })  : _numberOfParametersMetricTreshold = readNullableThreshold<int>(
          metricstTresholds,
          NumberOfParametersMetric.metricId,
        ),
        super(
          id: patternId,
          supportedType: EntityType.methodEntity,
          severity: readSeverity(patternSettings, Severity.none),
          excludes: readExcludes(patternSettings),
        );

  @override
  Iterable<Issue> check(
    InternalResolvedUnitResult source,
    Map<ScopedClassDeclaration, Report> classMetrics,
    Map<ScopedFunctionDeclaration, Report> functionMetrics,
  ) =>
      functionMetrics.entries
          .expand((entry) => [
                if (_numberOfParametersMetricTreshold != null)
                  ...entry.value.metrics
                      .where((metricValue) =>
                          metricValue.metricsId ==
                              NumberOfParametersMetric.metricId &&
                          metricValue.value >
                              _numberOfParametersMetricTreshold!)
                      .map(
                        (metricValue) => createIssue(
                          pattern: this,
                          location: nodeLocation(
                            node: entry.key.declaration,
                            source: source,
                          ),
                          message: _compileMessage(
                            args: metricValue.value,
                            functionType: entry.key.type,
                          ),
                          verboseMessage: _compileRecommendationMessage(
                            maximumArguments: _numberOfParametersMetricTreshold,
                            functionType: entry.key.type,
                          ),
                        ),
                      ),
                if (_numberOfParametersMetricTreshold == null)
                  // ignore: deprecated_member_use_from_same_package
                  ..._legacyBehaviour(source, entry),
              ])
          .toList();

  String _compileMessage({
    required num args,
    required FunctionType functionType,
  }) =>
      'Long Parameter List. This $functionType require $args arguments.';

  String? _compileRecommendationMessage({
    required num? maximumArguments,
    required FunctionType functionType,
  }) =>
      maximumArguments != null
          ? "Based on configuration of this package, we don't recommend writing a $functionType with argument count more than $maximumArguments."
          : null;

  @Deprecated('Fallback for current behaviour, will be removed in 5.0.0')
  Iterable<Issue> _legacyBehaviour(
    InternalResolvedUnitResult source,
    MapEntry<ScopedFunctionDeclaration, Report> entry,
  ) =>
      entry.value.metrics
          .where((metricValue) =>
              metricValue.metricsId == NumberOfParametersMetric.metricId &&
              metricValue.level == MetricValueLevel.none &&
              metricValue.value > 4)
          .map(
            (metricValue) => createIssue(
              pattern: this,
              location: nodeLocation(
                node: entry.key.declaration,
                source: source,
              ),
              message: _compileMessage(
                args: metricValue.value,
                functionType: entry.key.type,
              ),
              verboseMessage:
                  'Anti pattern works in deprecated mode. Please configure ${NumberOfParametersMetric.metricId} metric. For detailed information please read documentation.',
            ),
          );
}
