// ignore_for_file: public_member_api_docs
import 'package:code_checker/checker.dart';
import 'package:code_checker/metrics.dart';
import 'package:meta/meta.dart';
import 'package:source_span/source_span.dart';

@immutable
class FunctionRecord extends Report {
  final int argumentsCount;

  final Map<int, int> cyclomaticComplexityLines;

  final Iterable<int> linesWithCode;

  final Map<String, int> operators;
  final Map<String, int> operands;

  const FunctionRecord({
    @required SourceSpan location,
    @required Iterable<MetricValue<num>> metrics,
    @required this.argumentsCount,
    @required this.cyclomaticComplexityLines,
    @required this.linesWithCode,
    @required this.operators,
    @required this.operands,
  }) : super(location: location, metrics: metrics);
}
