import 'package:meta/meta.dart';

const cyclomaticComplexityDefaultWarningLevel = 20;
const linesOfExecutableCodeDefaultWarningLevel = 50;
const numberOfArgumentsDefaultWarningLevel = 4;
const numberOfMethodsDefaultWarningLevel = 10;

@Deprecated('Use linesOfExecutableCodeDefaultWarningLevel')
const linesOfCodeDefaultWarningLevel = linesOfExecutableCodeDefaultWarningLevel;

/// Reporter config to use with various [Reporter]s
@immutable
class Config {
  final int cyclomaticComplexityWarningLevel;
  final int linesOfExecutableCodeWarningLevel;
  final int numberOfArgumentsWarningLevel;
  final int numberOfMethodsWarningLevel;

  @Deprecated('Use linesOfExecutableCodeWarningLevel')
  int get linesOfCodeWarningLevel => linesOfExecutableCodeWarningLevel;

  const Config({
    this.cyclomaticComplexityWarningLevel =
        cyclomaticComplexityDefaultWarningLevel,
    this.numberOfArgumentsWarningLevel = numberOfArgumentsDefaultWarningLevel,
    this.numberOfMethodsWarningLevel = numberOfMethodsDefaultWarningLevel,
    @Deprecated('Use linesOfExecutableCodeWarningLevel')
        int linesOfCodeWarningLevel,
    int linesOfExecutableCodeWarningLevel =
        linesOfExecutableCodeDefaultWarningLevel,
  }) : linesOfExecutableCodeWarningLevel =
            // ignore: deprecated_member_use_from_same_package
            linesOfExecutableCodeWarningLevel ?? linesOfCodeWarningLevel;
}
