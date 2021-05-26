import 'package:meta/meta.dart';

import '../../metrics/models/metric_value.dart';

@immutable
class ClassMetricsReport {
  final MetricValue<int> methodsCount;
  final MetricValue<double> weightOfClass;

  const ClassMetricsReport({
    required this.methodsCount,
    required this.weightOfClass,
  });
}
