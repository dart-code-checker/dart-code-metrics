// ignore_for_file: public_member_api_docs

import '../../../../utils/node_utils.dart';
import '../../lint_utils.dart';
import '../../metrics/metric_utils.dart';
import '../../metrics/metrics_list/number_of_parameters_metric.dart';
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

  final int? _numberOfParametersMetricThreshold;

  @override
  Iterable<String> get dependentMetricIds =>
      [NumberOfParametersMetric.metricId];

  LongParameterList({
    Map<String, Object> patternSettings = const {},
    Map<String, Object> metricsThresholds = const {},
  })  : _numberOfParametersMetricThreshold = readNullableThreshold<int>(
          metricsThresholds,
          NumberOfParametersMetric.metricId,
        ),
        super(
          id: patternId,
          severity: readSeverity(patternSettings, Severity.warning),
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
                if (_numberOfParametersMetricThreshold != null)
                  ...entry.value.metrics
                      .where((metricValue) =>
                          metricValue.metricsId ==
                              NumberOfParametersMetric.metricId &&
                          metricValue.value >
                              _numberOfParametersMetricThreshold!)
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
                            maximumArguments:
                                _numberOfParametersMetricThreshold,
                            functionType: entry.key.type,
                          ),
                        ),
                      ),
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
}
