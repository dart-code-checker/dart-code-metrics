import 'package:meta/meta.dart';

@immutable
class Config {
  final int cyclomaticComplexityWarningLevel;
  final int linesOfCodeWarningLevel;

  const Config({@required this.cyclomaticComplexityWarningLevel, @required this.linesOfCodeWarningLevel});
}
