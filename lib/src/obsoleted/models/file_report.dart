// ignore_for_file: public_member_api_docs
import 'package:meta/meta.dart';

@immutable
class FileReport {
  final int averageArgumentsCount;
  final int argumentsCountViolations;

  final double averageMaintainabilityIndex;
  final int maintainabilityIndexViolations;

  final int averageMethodsCount;
  final int methodsCountViolations;

  final int totalCyclomaticComplexity;
  final int cyclomaticComplexityViolations;

  final int totalLinesOfExecutableCode;
  final int linesOfExecutableCodeViolations;

  final int averageMaximumNestingLevel;
  final int maximumNestingLevelViolations;

  const FileReport({
    @required this.averageArgumentsCount,
    @required this.argumentsCountViolations,
    @required this.averageMaintainabilityIndex,
    @required this.maintainabilityIndexViolations,
    @required this.averageMethodsCount,
    @required this.methodsCountViolations,
    @required this.totalCyclomaticComplexity,
    @required this.cyclomaticComplexityViolations,
    @required this.totalLinesOfExecutableCode,
    @required this.linesOfExecutableCodeViolations,
    @required this.averageMaximumNestingLevel,
    @required this.maximumNestingLevelViolations,
  });
}
