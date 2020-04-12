import 'package:dart_code_metrics/src/models/function_report_metric.dart';
import 'package:dart_code_metrics/src/models/violation_level.dart';
import 'package:meta/meta.dart';

@immutable
class FunctionReport {
  final FunctionReportMetric<int> cyclomaticComplexity;
  final FunctionReportMetric<int> linesOfCode;
  final FunctionReportMetric<double> maintainabilityIndex;

  final int argumentsCount;
  final ViolationLevel argumentsCountViolationLevel;

  const FunctionReport(
      {@required this.cyclomaticComplexity,
      @required this.linesOfCode,
      @required this.maintainabilityIndex,
      @required this.argumentsCount,
      @required this.argumentsCountViolationLevel});
}
