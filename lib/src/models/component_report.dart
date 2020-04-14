import 'package:meta/meta.dart';

ComponentReport mergeComponentReports(ComponentReport lhs,
        ComponentReport rhs) =>
    ComponentReport(
        averageArgumentsCount:
            ((lhs.averageArgumentsCount + rhs.averageArgumentsCount) / 2)
                .round(),
        totalArgumentsCountViolations: lhs.totalArgumentsCountViolations +
            rhs.totalArgumentsCountViolations,
        averageMaintainabilityIndex: (lhs.averageMaintainabilityIndex +
                rhs.averageMaintainabilityIndex) /
            2,
        totalMaintainabilityIndexViolations:
            lhs.totalMaintainabilityIndexViolations +
                rhs.totalMaintainabilityIndexViolations,
        totalCyclomaticComplexity:
            lhs.totalCyclomaticComplexity + rhs.totalCyclomaticComplexity,
        totalCyclomaticComplexityViolations:
            lhs.totalCyclomaticComplexityViolations +
                rhs.totalCyclomaticComplexityViolations,
        totalLinesOfCode: lhs.totalLinesOfCode + rhs.totalLinesOfCode,
        totalLinesOfCodeViolations:
            lhs.totalLinesOfCodeViolations + rhs.totalLinesOfCodeViolations);

@immutable
class ComponentReport {
  final int averageArgumentsCount;
  final int totalArgumentsCountViolations;

  final double averageMaintainabilityIndex;
  final int totalMaintainabilityIndexViolations;

  final int totalCyclomaticComplexity;
  final int totalCyclomaticComplexityViolations;

  final int totalLinesOfCode;
  final int totalLinesOfCodeViolations;

  const ComponentReport(
      {@required this.averageArgumentsCount,
      @required this.totalArgumentsCountViolations,
      @required this.averageMaintainabilityIndex,
      @required this.totalMaintainabilityIndexViolations,
      @required this.totalCyclomaticComplexity,
      @required this.totalCyclomaticComplexityViolations,
      @required this.totalLinesOfCode,
      @required this.totalLinesOfCodeViolations});
}
