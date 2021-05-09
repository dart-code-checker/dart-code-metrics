import 'package:meta/meta.dart';

@immutable
class FileMetricsReport {
  final int averageArgumentsCount;
  final int argumentsCountViolations;

  final double averageMaintainabilityIndex;
  final int maintainabilityIndexViolations;

  final int averageMethodsCount;
  final int methodsCountViolations;

  final int totalCyclomaticComplexity;
  final int cyclomaticComplexityViolations;

  final int totalSourceLinesOfCode;
  final int sourceLinesOfCodeViolations;

  final int averageMaximumNestingLevel;
  final int maximumNestingLevelViolations;

  const FileMetricsReport({
    required this.averageArgumentsCount,
    required this.argumentsCountViolations,
    required this.averageMaintainabilityIndex,
    required this.maintainabilityIndexViolations,
    required this.averageMethodsCount,
    required this.methodsCountViolations,
    required this.totalCyclomaticComplexity,
    required this.cyclomaticComplexityViolations,
    required this.totalSourceLinesOfCode,
    required this.sourceLinesOfCodeViolations,
    required this.averageMaximumNestingLevel,
    required this.maximumNestingLevelViolations,
  });
}
