import '../models/entity_type.dart';
import 'metrics_list/cyclomatic_complexity/cyclomatic_complexity_metric.dart';
import 'metrics_list/halstead_volume/halstead_volume_metric.dart';
import 'metrics_list/lines_of_code_metric.dart';
import 'metrics_list/maintainability_index_metric.dart';
import 'metrics_list/maximum_nesting_level/maximum_nesting_level_metric.dart';
import 'metrics_list/number_of_methods_metric.dart';
import 'metrics_list/number_of_parameters_metric.dart';
import 'metrics_list/source_lines_of_code/source_lines_of_code_metric.dart';
import 'metrics_list/technical_debt/technical_debt_metric.dart';
import 'metrics_list/weight_of_class_metric.dart';
import 'models/metric.dart';

final _implementedMetrics = <String, Metric Function(Map<String, Object>)>{
  CyclomaticComplexityMetric.metricId: (config) =>
      CyclomaticComplexityMetric(config: config),
  HalsteadVolumeMetric.metricId: (config) =>
      HalsteadVolumeMetric(config: config),
  LinesOfCodeMetric.metricId: (config) => LinesOfCodeMetric(config: config),
  MaximumNestingLevelMetric.metricId: (config) =>
      MaximumNestingLevelMetric(config: config),
  NumberOfMethodsMetric.metricId: (config) =>
      NumberOfMethodsMetric(config: config),
  NumberOfParametersMetric.metricId: (config) =>
      NumberOfParametersMetric(config: config),
  SourceLinesOfCodeMetric.metricId: (config) =>
      SourceLinesOfCodeMetric(config: config),
  WeightOfClassMetric.metricId: (config) => WeightOfClassMetric(config: config),
  // Complex metrics:
  // Depends on CyclomaticComplexityMetric, HalsteadVolumeMetric and SourceLinesOfCodeMetric metrics
  MaintainabilityIndexMetric.metricId: (config) =>
      MaintainabilityIndexMetric(config: config),
  // Depends on all metrics.
  TechnicalDebtMetric.metricId: (config) => TechnicalDebtMetric(config: config),
};

Iterable<Metric> getMetrics({
  required Map<String, Object> config,
  Iterable<String> patternsDependencies = const [],
  EntityType? measuredType,
}) {
  final metrics = _implementedMetrics.keys.map(
    (id) => _implementedMetrics[id]!(
      !patternsDependencies.contains(id) ? config : {},
    ),
  );

  return measuredType != null
      ? metrics
          .where((metric) => metric.documentation.measuredType == measuredType)
          .toList()
      : metrics;
}
