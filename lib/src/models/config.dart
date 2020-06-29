import 'package:meta/meta.dart';

const cyclomaticComplexityDefaultWarningLevel = 20;
const linesOfCodeDefaultWarningLevel = 50;
const numberOfArgumentsDefaultWarningLevel = 4;
const numberOfMethodsDefaultWarningLevel = 10;

/// Reporter config to use with various [Reporter]s
@immutable
class Config {
  final int cyclomaticComplexityWarningLevel;
  final int linesOfCodeWarningLevel;
  final int numberOfArgumentsWarningLevel;
  final int numberOfMethodsWarningLevel;

  const Config({
    this.cyclomaticComplexityWarningLevel =
        cyclomaticComplexityDefaultWarningLevel,
    this.linesOfCodeWarningLevel = linesOfCodeDefaultWarningLevel,
    this.numberOfArgumentsWarningLevel = numberOfArgumentsDefaultWarningLevel,
    this.numberOfMethodsWarningLevel = numberOfMethodsDefaultWarningLevel,
  });
}
