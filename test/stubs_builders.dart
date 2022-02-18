import 'package:analyzer/dart/ast/ast.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/metrics_list/cyclomatic_complexity/cyclomatic_complexity_metric.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/metrics_list/maximum_nesting_level/maximum_nesting_level_metric.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/metrics_list/number_of_methods_metric.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/metrics_list/number_of_parameters_metric.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/metrics_list/source_lines_of_code/source_lines_of_code_metric.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/metrics_list/weight_of_class_metric.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/models/metric_documentation.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/models/metric_value.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/models/metric_value_level.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/entity_type.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/report.dart';
import 'package:mocktail/mocktail.dart';
import 'package:source_span/source_span.dart';

class _DeclarationMock extends Mock implements Declaration {}

MetricValue<T> buildMetricValueStub<T extends num>({
  required String id,
  required T value,
  String? unitType,
  EntityType type = EntityType.methodEntity,
  MetricValueLevel level = MetricValueLevel.none,
}) =>
    MetricValue<T>(
      metricsId: id,
      documentation: MetricDocumentation(
        name: id,
        shortName: id.toUpperCase(),
        measuredType: type,
        recommendedThreshold: 0,
      ),
      value: value,
      unitType: unitType,
      level: level,
      comment: '',
    );

Report buildReportStub({
  SourceSpanBase? location,
  Iterable<MetricValue> metrics = const [],
}) {
  const defaultMetricValues = [
    MetricValue<int>(
      metricsId: NumberOfMethodsMetric.metricId,
      documentation: MetricDocumentation(
        name: 'metric1',
        shortName: 'MTR1',
        measuredType: EntityType.classEntity,
        recommendedThreshold: 0,
      ),
      value: 0,
      level: MetricValueLevel.none,
      comment: '',
    ),
    MetricValue<double>(
      metricsId: WeightOfClassMetric.metricId,
      documentation: MetricDocumentation(
        name: 'metric2',
        shortName: 'MTR2',
        measuredType: EntityType.methodEntity,
        recommendedThreshold: 0,
      ),
      value: 1,
      level: MetricValueLevel.none,
      comment: '',
    ),
  ];

  return Report(
    location:
        location ?? SourceSpanBase(SourceLocation(0), SourceLocation(0), ''),
    declaration: _DeclarationMock(),
    metrics: [...metrics, ...defaultMetricValues],
  );
}

Report buildFunctionRecordStub({
  SourceSpanBase? location,
  Iterable<MetricValue> metrics = const [],
}) {
  final defaultMetricValues = [
    buildMetricValueStub<int>(
      id: CyclomaticComplexityMetric.metricId,
      value: 0,
    ),
    buildMetricValueStub<int>(id: MaximumNestingLevelMetric.metricId, value: 0),
    buildMetricValueStub<int>(id: NumberOfParametersMetric.metricId, value: 0),
    buildMetricValueStub<int>(id: SourceLinesOfCodeMetric.metricId, value: 0),
    buildMetricValueStub<int>(id: 'maintainability-index', value: 100),
  ];

  return Report(
    location:
        location ?? SourceSpanBase(SourceLocation(0), SourceLocation(0), ''),
    declaration: _DeclarationMock(),
    metrics: [...metrics, ...defaultMetricValues],
  );
}
