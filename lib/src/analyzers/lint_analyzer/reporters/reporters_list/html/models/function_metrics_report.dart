// ignore_for_file: public_member_api_docs

import '../../../../metrics/models/metric_value.dart';

class FunctionMetricsReport {
  final MetricValue<int> cyclomaticComplexity;
  final MetricValue<int> sourceLinesOfCode;
  final MetricValue<int> maintainabilityIndex;
  final MetricValue<int> argumentsCount;
  final MetricValue<int> maximumNestingLevel;

  const FunctionMetricsReport({
    required this.cyclomaticComplexity,
    required this.sourceLinesOfCode,
    required this.maintainabilityIndex,
    required this.argumentsCount,
    required this.maximumNestingLevel,
  });
}
