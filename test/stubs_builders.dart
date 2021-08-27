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
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/reporters/reporters_list/html/models/function_metrics_report.dart';
import 'package:mocktail/mocktail.dart';
import 'package:source_span/source_span.dart';

class _DeclarationMock extends Mock implements Declaration {}

MetricValue<T> buildMetricValueStub<T>({
  required String id,
  required T value,
  EntityType type = EntityType.methodEntity,
  MetricValueLevel level = MetricValueLevel.none,
}) =>
    MetricValue<T>(
      metricsId: id,
      documentation: MetricDocumentation(
        name: id,
        shortName: id.toUpperCase(),
        brief: 'brief $id',
        measuredType: type,
        recomendedThreshold: 0,
      ),
      value: value,
      level: level,
      comment: '',
    );

Report buildRecordStub({
  SourceSpanBase? location,
  Iterable<MetricValue<num>> metrics = const [],
}) {
  const defaultMetricValues = [
    MetricValue<int>(
      metricsId: NumberOfMethodsMetric.metricId,
      documentation: MetricDocumentation(
        name: 'metric1',
        shortName: 'MTR1',
        brief: '',
        measuredType: EntityType.classEntity,
        recomendedThreshold: 0,
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
        brief: '',
        measuredType: EntityType.methodEntity,
        recomendedThreshold: 0,
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
  Iterable<MetricValue<num>> metrics = const [],
}) {
  final defaultMetricValues = [
    buildMetricValueStub<int>(
      id: CyclomaticComplexityMetric.metricId,
      value: 0,
    ),
    buildMetricValueStub<int>(id: MaximumNestingLevelMetric.metricId, value: 0),
    buildMetricValueStub<int>(id: NumberOfParametersMetric.metricId, value: 0),
    buildMetricValueStub<int>(id: SourceLinesOfCodeMetric.metricId, value: 0),
    buildMetricValueStub<double>(id: 'maintainability-index', value: 100),
  ];

  return Report(
    location:
        location ?? SourceSpanBase(SourceLocation(0), SourceLocation(0), ''),
    declaration: _DeclarationMock(),
    metrics: [...metrics, ...defaultMetricValues],
  );
}

FunctionMetricsReport buildFunctionMetricsReportStub({
  int cyclomaticComplexity = 0,
  MetricValueLevel cyclomaticComplexityViolationLevel = MetricValueLevel.none,
  int sourceLinesOfCode = 0,
  MetricValueLevel sourceLinesOfCodeViolationLevel = MetricValueLevel.none,
  double maintainabilityIndex = 0,
  MetricValueLevel maintainabilityIndexViolationLevel = MetricValueLevel.none,
  int argumentsCount = 0,
  MetricValueLevel argumentsCountViolationLevel = MetricValueLevel.none,
  int maximumNestingLevel = 0,
  MetricValueLevel maximumNestingLevelViolationLevel = MetricValueLevel.none,
}) =>
    FunctionMetricsReport(
      cyclomaticComplexity: MetricValue<int>(
        metricsId: '',
        documentation: const MetricDocumentation(
          name: '',
          shortName: '',
          brief: '',
          measuredType: EntityType.classEntity,
          recomendedThreshold: 0,
        ),
        value: cyclomaticComplexity,
        level: cyclomaticComplexityViolationLevel,
        comment: '',
      ),
      sourceLinesOfCode: MetricValue<int>(
        metricsId: '',
        documentation: const MetricDocumentation(
          name: '',
          shortName: '',
          brief: '',
          measuredType: EntityType.classEntity,
          recomendedThreshold: 0,
        ),
        value: sourceLinesOfCode,
        level: sourceLinesOfCodeViolationLevel,
        comment: '',
      ),
      maintainabilityIndex: MetricValue<double>(
        metricsId: '',
        documentation: const MetricDocumentation(
          name: '',
          shortName: '',
          brief: '',
          measuredType: EntityType.classEntity,
          recomendedThreshold: 0,
        ),
        value: maintainabilityIndex,
        level: maintainabilityIndexViolationLevel,
        comment: '',
      ),
      argumentsCount: MetricValue<int>(
        metricsId: '',
        documentation: const MetricDocumentation(
          name: '',
          shortName: '',
          brief: '',
          measuredType: EntityType.classEntity,
          recomendedThreshold: 0,
        ),
        value: argumentsCount,
        level: argumentsCountViolationLevel,
        comment: '',
      ),
      maximumNestingLevel: MetricValue<int>(
        metricsId: '',
        documentation: const MetricDocumentation(
          name: '',
          shortName: '',
          brief: '',
          measuredType: EntityType.classEntity,
          recomendedThreshold: 0,
        ),
        value: maximumNestingLevel,
        level: maximumNestingLevelViolationLevel,
        comment: '',
      ),
    );
