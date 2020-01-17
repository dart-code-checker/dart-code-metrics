import 'package:built_collection/built_collection.dart';
import 'package:meta/meta.dart';

@immutable
class FunctionRecord {
  final int firstLine;
  final int lastLine;

  final BuiltMap<int, int> cyclomaticLinesComplexity;

  final Iterable<int> linesWithCode;

  final BuiltMap<String, int> operators;
  final BuiltMap<String, int> operands;

  const FunctionRecord(
      {@required this.firstLine,
      @required this.lastLine,
      @required this.cyclomaticLinesComplexity,
      @required this.linesWithCode,
      @required this.operators,
      @required this.operands});
}
