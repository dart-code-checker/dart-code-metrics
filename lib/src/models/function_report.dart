import 'package:meta/meta.dart';

import 'report_metric.dart';

@immutable
class FunctionReport {
  final ReportMetric<int> cyclomaticComplexity;
  final ReportMetric<int> linesOfExecutableCode;
  final ReportMetric<double> maintainabilityIndex;
  final ReportMetric<int> argumentsCount;

  const FunctionReport(
      {@required this.cyclomaticComplexity,
      @required this.linesOfExecutableCode,
      @required this.maintainabilityIndex,
      @required this.argumentsCount});
}
