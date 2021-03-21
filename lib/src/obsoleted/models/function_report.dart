// ignore_for_file: public_member_api_docs
import 'package:code_checker/metrics.dart';
import 'package:meta/meta.dart';

@immutable
class FunctionReport {
  final MetricValue<int> cyclomaticComplexity;
  final MetricValue<int> linesOfExecutableCode;
  final MetricValue<double> maintainabilityIndex;
  final MetricValue<int> argumentsCount;
  final MetricValue<int> maximumNestingLevel;

  const FunctionReport({
    @required this.cyclomaticComplexity,
    @required this.linesOfExecutableCode,
    @required this.maintainabilityIndex,
    @required this.argumentsCount,
    @required this.maximumNestingLevel,
  });
}
