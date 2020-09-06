import 'package:meta/meta.dart';

const cyclomaticComplexityDefaultWarningLevel = 20;
const linesOfExecutableCodeDefaultWarningLevel = 50;
const numberOfArgumentsDefaultWarningLevel = 4;
const numberOfMethodsDefaultWarningLevel = 10;

/// Reporter config to use with various [Reporter]s
@immutable
class Config {
  final int cyclomaticComplexityWarningLevel;
  final int linesOfExecutableCodeWarningLevel;
  final int numberOfArgumentsWarningLevel;
  final int numberOfMethodsWarningLevel;

  const Config({
    this.cyclomaticComplexityWarningLevel =
        cyclomaticComplexityDefaultWarningLevel,
    this.linesOfExecutableCodeWarningLevel =
        linesOfExecutableCodeDefaultWarningLevel,
    this.numberOfArgumentsWarningLevel = numberOfArgumentsDefaultWarningLevel,
    this.numberOfMethodsWarningLevel = numberOfMethodsDefaultWarningLevel,
  });
}
