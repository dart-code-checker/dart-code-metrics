import 'package:meta/meta.dart';

@immutable
class ComponentRecord {
  final int firstLine;
  final int lastLine;

  final int methodsCount;

  const ComponentRecord(
      {@required this.firstLine,
      @required this.lastLine,
      @required this.methodsCount});
}
