// ignore_for_file: comment_references
import 'package:meta/meta.dart';

const cyclomaticComplexityKey = 'cyclomatic-complexity';
const linesOfExecutableCodeKey = 'lines-of-executable-code';
const numberOfArgumentsKey = 'number-of-arguments';
const numberOfMethodsKey = 'number-of-methods';
const maximumNestingKey = 'maximum-nesting';
const weightOfClassKey = 'weight-of-class';

const cyclomaticComplexityDefaultWarningLevel = 20;
const linesOfExecutableCodeDefaultWarningLevel = 50;
const numberOfArgumentsDefaultWarningLevel = 4;
const numberOfMethodsDefaultWarningLevel = 10;
const maximumNestingDefaultWarningLevel = 5;
const weightOfClassDefaultWarningLevel = 0.33;

/// Reporter config to use with various [Reporter]s
@immutable
class Config {
  final int cyclomaticComplexityWarningLevel;
  final int linesOfExecutableCodeWarningLevel;
  final int numberOfArgumentsWarningLevel;
  final int numberOfMethodsWarningLevel;
  final int maximumNestingWarningLevel;
  final double weightOfClassWarningLevel;

  const Config({
    int? cyclomaticComplexityWarningLevel,
    int? linesOfExecutableCodeWarningLevel,
    int? numberOfArgumentsWarningLevel,
    int? numberOfMethodsWarningLevel,
    int? maximumNestingWarningLevel,
    double? weightOfClassWarningLevel,
  })  : cyclomaticComplexityWarningLevel = cyclomaticComplexityWarningLevel ??
            cyclomaticComplexityDefaultWarningLevel,
        linesOfExecutableCodeWarningLevel = linesOfExecutableCodeWarningLevel ??
            linesOfExecutableCodeDefaultWarningLevel,
        numberOfArgumentsWarningLevel = numberOfArgumentsWarningLevel ??
            numberOfArgumentsDefaultWarningLevel,
        numberOfMethodsWarningLevel =
            numberOfMethodsWarningLevel ?? numberOfMethodsDefaultWarningLevel,
        maximumNestingWarningLevel =
            maximumNestingWarningLevel ?? maximumNestingDefaultWarningLevel,
        weightOfClassWarningLevel =
            weightOfClassWarningLevel ?? weightOfClassDefaultWarningLevel;
}
