import 'package:meta/meta.dart';

/// Reporter config to use with various [Reporter]s
@immutable
class Config {
  final int cyclomaticComplexityWarningLevel;
  final int linesOfCodeWarningLevel;

  const Config(
      {@required this.cyclomaticComplexityWarningLevel,
      @required this.linesOfCodeWarningLevel});
}
