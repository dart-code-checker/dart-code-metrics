import 'metrics/cyclomatic_complexity/cyclomatic_complexity_metric.dart';
import 'metrics/lines_of_code_metric.dart';
import 'metrics/maximum_nesting_level/maximum_nesting_level_metric.dart';
import 'metrics/metric.dart';
import 'metrics/number_of_methods_metric.dart';
import 'metrics/number_of_parameters_metric.dart';
import 'metrics/weight_of_class_metric.dart';
import 'models/entity_type.dart';

final _implementedMetrics = <String, Metric Function(Map<String, Object>)>{
  CyclomaticComplexityMetric.metricId: (config) =>
      CyclomaticComplexityMetric(config: config),
  LinesOfCodeMetric.metricId: (config) => LinesOfCodeMetric(config: config),
  MaximumNestingLevelMetric.metricId: (config) =>
      MaximumNestingLevelMetric(config: config),
  NumberOfMethodsMetric.metricId: (config) =>
      NumberOfMethodsMetric(config: config),
  NumberOfParametersMetric.metricId: (config) =>
      NumberOfParametersMetric(config: config),
  WeightOfClassMetric.metricId: (config) => WeightOfClassMetric(config: config),
};

Iterable<Metric> metrics({
  required Map<String, Object> config,
  EntityType? measuredType,
}) {
  final _metrics =
      _implementedMetrics.keys.map((id) => _implementedMetrics[id]!(config));

  return measuredType != null
      ? _metrics
          .where((metric) => metric.documentation.measuredType == measuredType)
          .toList()
      : _metrics;
}
