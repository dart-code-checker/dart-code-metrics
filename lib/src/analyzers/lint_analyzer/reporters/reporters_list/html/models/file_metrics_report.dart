// ignore_for_file: public_member_api_docs

class FileMetricsReport {
  final int averageArgumentsCount;
  final int argumentsCountViolations;

  final double averageMaintainabilityIndex;
  final int maintainabilityIndexViolations;

  final int totalCyclomaticComplexity;
  final int cyclomaticComplexityViolations;

  final int totalSourceLinesOfCode;
  final int sourceLinesOfCodeViolations;

  final int averageMaximumNestingLevel;
  final int maximumNestingLevelViolations;

  final double technicalDebt;
  final int technicalDebtViolations;
  final String? technicalDebtUnitType;

  const FileMetricsReport({
    required this.averageArgumentsCount,
    required this.argumentsCountViolations,
    required this.averageMaintainabilityIndex,
    required this.maintainabilityIndexViolations,
    required this.totalCyclomaticComplexity,
    required this.cyclomaticComplexityViolations,
    required this.totalSourceLinesOfCode,
    required this.sourceLinesOfCodeViolations,
    required this.averageMaximumNestingLevel,
    required this.maximumNestingLevelViolations,
    required this.technicalDebt,
    required this.technicalDebtViolations,
    required this.technicalDebtUnitType,
  });
}
