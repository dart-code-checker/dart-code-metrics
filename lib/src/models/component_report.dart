import 'package:code_checker/metrics.dart';
import 'package:meta/meta.dart';

@immutable
class ComponentReport {
  final MetricValue<int> methodsCount;

  const ComponentReport({@required this.methodsCount});
}
