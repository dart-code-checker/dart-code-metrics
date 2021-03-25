import 'package:dart_code_metrics/src/metrics/maximum_nesting_level/maximum_nesting_level_metric.dart';
import 'package:dart_code_metrics/src/metrics/number_of_methods_metric.dart';
import 'package:dart_code_metrics/src/metrics/weight_of_class_metric.dart';
import 'package:dart_code_metrics/src/models/entity_type.dart';
import 'package:dart_code_metrics/src/models/metric_documentation.dart';
import 'package:dart_code_metrics/src/models/metric_value.dart';
import 'package:dart_code_metrics/src/models/metric_value_level.dart';
import 'package:dart_code_metrics/src/models/report.dart';
import 'package:dart_code_metrics/src/obsoleted/models/component_report.dart';
import 'package:dart_code_metrics/src/obsoleted/models/function_record.dart';
import 'package:dart_code_metrics/src/obsoleted/models/function_report.dart';
import 'package:source_span/source_span.dart';

Report buildComponentRecordStub({
  SourceSpanBase location,
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

FunctionRecord buildFunctionRecordStub({
  SourceSpanBase location,
  Iterable<MetricValue<num>> metrics = const [],
  int argumentsCount = 0,
  Map<int, int> cyclomaticLinesComplexity = const <int, int>{},
  Iterable<int> linesWithCode = const <int>[],
  Map<int, int> operators = const <int, int>{},
  Map<int, int> operands = const <int, int>{},
}) {
  const defaultMetricValue = MetricValue<int>(
    metricsId: MaximumNestingLevelMetric.metricId,
    documentation: MetricDocumentation(
      name: 'metric1',
      shortName: 'MTR1',
      brief: '',
      measuredType: EntityType.methodEntity,
      examples: [],
    ),
    value: 0,
    level: MetricValueLevel.none,
    comment: '',
  );

  return FunctionRecord(
    location:
        location ?? SourceSpanBase(SourceLocation(0), SourceLocation(0), ''),
    metrics: [...metrics, defaultMetricValue],
    argumentsCount: argumentsCount,
    cyclomaticComplexityLines: Map.unmodifiable(cyclomaticLinesComplexity),
    linesWithCode: linesWithCode,
    operators: Map.unmodifiable(operators),
    operands: Map.unmodifiable(operands),
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
        value: cyclomaticComplexity,
        level: cyclomaticComplexityViolationLevel,
        comment: '',
      ),
      linesOfExecutableCode: MetricValue<int>(
        metricsId: '',
        value: linesOfExecutableCode,
        level: linesOfExecutableCodeViolationLevel,
        comment: '',
      ),
      maintainabilityIndex: MetricValue<double>(
        metricsId: '',
        value: maintainabilityIndex,
        level: maintainabilityIndexViolationLevel,
        comment: '',
      ),
      argumentsCount: MetricValue<int>(
        metricsId: '',
        value: argumentsCount,
        level: argumentsCountViolationLevel,
        comment: '',
      ),
      maximumNestingLevel: MetricValue<int>(
        metricsId: '',
        value: maximumNestingLevel,
        level: maximumNestingLevelViolationLevel,
        comment: '',
      ),
    );
