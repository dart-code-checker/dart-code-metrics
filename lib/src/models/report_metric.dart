import 'package:code_checker/metrics.dart';
import 'package:meta/meta.dart';

@immutable
class ReportMetric<T> {
  final T value;
  final MetricValueLevel violationLevel;

  const ReportMetric({@required this.value, @required this.violationLevel});
}
