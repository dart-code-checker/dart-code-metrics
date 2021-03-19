import 'package:code_checker/checker.dart';
import 'package:code_checker/metrics.dart';
import 'package:dart_code_metrics/src/obsoleted/models/component_report.dart';
import 'package:dart_code_metrics/src/obsoleted/models/function_record.dart';
import 'package:dart_code_metrics/src/obsoleted/models/function_report.dart'
    as metrics;
import 'package:source_span/source_span.dart';

Report buildComponentRecordStub({
  SourceSpanBase location,
  Iterable<MetricValue<num>> metrics = const [],
}) {
  const defaultMetricValues = [
    MetricValue<int>(
      metricsId: NumberOfMethodsMetric.metricId,
      value: 0,
      level: MetricValueLevel.none,
      comment: '',
    ),
    MetricValue<double>(
      metricsId: WeightOfClassMetric.metricId,
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
        value: methodsCount,
        level: methodsCountViolationLevel,
        comment: '',
      ),
      weightOfClass: MetricValue<double>(
        metricsId: '',
        value: weightOfClass,
        level: weightOfClassViolationLevel,
        comment: '',
      ),
    );

metrics.FunctionReport buildFunctionReportStub({
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
    metrics.FunctionReport(
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
