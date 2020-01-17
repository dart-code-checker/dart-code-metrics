import 'package:meta/meta.dart';

@immutable
class ComponentReport {
  final double averageMaintainabilityIndex;
  final int totalMaintainabilityIndexViolations;

  final int totalCyclomaticComplexity;
  final int totalCyclomaticComplexityViolations;

  final int totalLinesOfCode;
  final int totalLinesOfCodeViolations;

  const ComponentReport(
      {@required this.averageMaintainabilityIndex,
      @required this.totalMaintainabilityIndexViolations,
      @required this.totalCyclomaticComplexity,
      @required this.totalCyclomaticComplexityViolations,
      @required this.totalLinesOfCode,
      @required this.totalLinesOfCodeViolations});
}
