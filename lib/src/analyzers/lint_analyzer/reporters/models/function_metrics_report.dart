import 'package:meta/meta.dart';

import '../../metrics/models/metric_value.dart';

@immutable
class FunctionMetricsReport {
  final MetricValue<int> cyclomaticComplexity;
  final MetricValue<int> linesOfExecutableCode;
  final MetricValue<double> maintainabilityIndex;
  final MetricValue<int> argumentsCount;
  final MetricValue<int> maximumNestingLevel;

  const FunctionMetricsReport({
    required this.cyclomaticComplexity,
    required this.linesOfExecutableCode,
    required this.maintainabilityIndex,
    required this.argumentsCount,
    required this.maximumNestingLevel,
  });
}
