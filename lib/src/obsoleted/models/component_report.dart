import 'package:code_checker/metrics.dart';
import 'package:meta/meta.dart';

@immutable
class ComponentReport {
  final MetricValue<int> methodsCount;
  final MetricValue<double> weightOfClass;

  const ComponentReport({
    @required this.methodsCount,
    @required this.weightOfClass,
  });
}
