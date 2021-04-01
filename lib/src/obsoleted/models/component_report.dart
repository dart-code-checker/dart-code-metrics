import 'package:meta/meta.dart';

import '../../models/metric_value.dart';

@immutable
class ComponentReport {
  final MetricValue<int> methodsCount;
  final MetricValue<double> weightOfClass;

  const ComponentReport({
    required this.methodsCount,
    required this.weightOfClass,
  });
}
