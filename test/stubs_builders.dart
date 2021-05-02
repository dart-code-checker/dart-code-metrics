import 'package:dart_code_metrics/src/analyzers/lint_analyzer/constants.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/metrics_list/cyclomatic_complexity/cyclomatic_complexity_metric.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/metrics_list/maximum_nesting_level/maximum_nesting_level_metric.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/metrics_list/number_of_methods_metric.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/metrics_list/number_of_parameters_metric.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/metrics_list/weight_of_class_metric.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/models/entity_type.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/models/metric_documentation.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/models/metric_value.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/models/metric_value_level.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/reporters/models/component_report.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/reporters/models/function_report.dart';
import 'package:dart_code_metrics/src/analyzers/models/report.dart';
import 'package:source_span/source_span.dart';

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
        examples: const [],
      ),
      value: value,
      level: level,
      comment: '',
    );

Report buildComponentRecordStub({
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
        examples: [],
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
        examples: [],
      ),
      value: 1,
      level: MetricValueLevel.none,
      comment: '',
    ),
  ];

  return Report(
    location:
        location ?? SourceSpanBase(SourceLocation(0), SourceLocation(0), ''),
    metrics: [...metrics, ...defaultMetricValues],
  );
}

Report buildFunctionRecordStub({
  SourceSpanBase? location,
  Iterable<MetricValue<num>> metrics = const [],
  Map<int, int> cyclomaticLinesComplexity = const <int, int>{},
  Map<int, int> operators = const <int, int>{},
  Map<int, int> operands = const <int, int>{},
}) {
  final defaultMetricValues = [
    buildMetricValueStub<int>(
      id: CyclomaticComplexityMetric.metricId,
      value: 0,
    ),
    buildMetricValueStub<int>(id: MaximumNestingLevelMetric.metricId, value: 0),
    buildMetricValueStub<int>(id: NumberOfParametersMetric.metricId, value: 0),
    buildMetricValueStub<int>(id: linesOfExecutableCodeKey, value: 0),
    buildMetricValueStub<double>(id: 'maintainability-index', value: 100),
  ];

  return Report(
    location:
        location ?? SourceSpanBase(SourceLocation(0), SourceLocation(0), ''),
    metrics: [...metrics, ...defaultMetricValues],
  );
}

ComponentReport buildComponentReportStub({
  int methodsCount = 0,
  MetricValueLevel methodsCountViolationLevel = MetricValueLevel.none,
  double weightOfClass = 1,
  MetricValueLevel weightOfClassViolationLevel = MetricValueLevel.none,
}) =>
    ComponentReport(
      methodsCount: MetricValue<int>(
        metricsId: '',
        documentation: const MetricDocumentation(
          name: 'metric1',
          shortName: 'MTR1',
          brief: '',
          measuredType: EntityType.classEntity,
          examples: [],
        ),
        value: methodsCount,
        level: methodsCountViolationLevel,
        comment: '',
      ),
      weightOfClass: MetricValue<double>(
        metricsId: '',
        documentation: const MetricDocumentation(
          name: 'metric2',
          shortName: 'MTR2',
          brief: '',
          measuredType: EntityType.classEntity,
          examples: [],
        ),
        value: weightOfClass,
        level: weightOfClassViolationLevel,
        comment: '',
      ),
    );

FunctionReport buildFunctionReportStub({
  int cyclomaticComplexity = 0,
  MetricValueLevel cyclomaticComplexityViolationLevel = MetricValueLevel.none,
  int linesOfExecutableCode = 0,
  MetricValueLevel linesOfExecutableCodeViolationLevel = MetricValueLevel.none,
  double maintainabilityIndex = 0,
  MetricValueLevel maintainabilityIndexViolationLevel = MetricValueLevel.none,
  int argumentsCount = 0,
  MetricValueLevel argumentsCountViolationLevel = MetricValueLevel.none,
  int maximumNestingLevel = 0,
  MetricValueLevel maximumNestingLevelViolationLevel = MetricValueLevel.none,
}) =>
    FunctionReport(
      cyclomaticComplexity: MetricValue<int>(
        metricsId: '',
        documentation: const MetricDocumentation(
          name: '',
          shortName: '',
          brief: '',
          measuredType: EntityType.classEntity,
          examples: [],
        ),
        value: cyclomaticComplexity,
        level: cyclomaticComplexityViolationLevel,
        comment: '',
      ),
      linesOfExecutableCode: MetricValue<int>(
        metricsId: '',
        documentation: const MetricDocumentation(
          name: '',
          shortName: '',
          brief: '',
          measuredType: EntityType.classEntity,
          examples: [],
        ),
        value: linesOfExecutableCode,
        level: linesOfExecutableCodeViolationLevel,
        comment: '',
      ),
      maintainabilityIndex: MetricValue<double>(
        metricsId: '',
        documentation: const MetricDocumentation(
          name: '',
          shortName: '',
          brief: '',
          measuredType: EntityType.classEntity,
          examples: [],
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
          examples: [],
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
          examples: [],
        ),
        value: maximumNestingLevel,
        level: maximumNestingLevelViolationLevel,
        comment: '',
      ),
    );
