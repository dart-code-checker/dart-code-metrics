import 'package:meta/meta.dart';

@immutable
class FunctionRecord {
  final int firstLine;
  final int lastLine;

  final int argumentsCount;

  final Map<int, int> cyclomaticComplexityLines;

  final Iterable<int> linesWithCode;

  final Map<String, int> operators;
  final Map<String, int> operands;

  const FunctionRecord(
      {@required this.firstLine,
      @required this.lastLine,
      @required this.argumentsCount,
      @required this.cyclomaticComplexityLines,
      @required this.linesWithCode,
      @required this.operators,
      @required this.operands});
}
