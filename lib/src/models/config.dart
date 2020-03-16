import 'package:meta/meta.dart';

const cyclomaticComplexityDefaultWarningLevel = 20;
const linesOfCodeDefaultWarningLevel = 50;

/// Reporter config to use with various [Reporter]s
@immutable
class Config {
  final int cyclomaticComplexityWarningLevel;
  final int linesOfCodeWarningLevel;

  const Config(
      {this.cyclomaticComplexityWarningLevel =
          cyclomaticComplexityDefaultWarningLevel,
      this.linesOfCodeWarningLevel = linesOfCodeDefaultWarningLevel});
}
