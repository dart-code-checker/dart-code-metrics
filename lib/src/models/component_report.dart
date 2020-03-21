import 'package:meta/meta.dart';

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
