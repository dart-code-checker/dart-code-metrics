import 'package:meta/meta.dart';

@immutable
class ComponentRecord {
  final int firstLine;
  final int lastLine;

  final int methodsCount;
  final double weightOfClass;

  const ComponentRecord({
    @required this.firstLine,
    @required this.lastLine,
    @required this.methodsCount,
    @required this.weightOfClass,
  });
}
