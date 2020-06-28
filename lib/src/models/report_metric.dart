import 'package:dart_code_metrics/src/models/violation_level.dart';
import 'package:meta/meta.dart';

@immutable
class ReportMetric<T> {
  final T value;
  final ViolationLevel violationLevel;

  const ReportMetric({@required this.value, @required this.violationLevel});
}
