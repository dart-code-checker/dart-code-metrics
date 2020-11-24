import 'package:meta/meta.dart';

@immutable
class FileReport {
  final int averageArgumentsCount;
  final int totalArgumentsCountViolations;

  final double averageMaintainabilityIndex;
  final int totalMaintainabilityIndexViolations;

  final int averageMethodsCount;
  final int totalMethodsCountViolations;

  final int totalCyclomaticComplexity;
  final int totalCyclomaticComplexityViolations;

  final int totalLinesOfExecutableCode;
  final int totalLinesOfExecutableCodeViolations;

  const FileReport({
    @required this.averageArgumentsCount,
    @required this.totalArgumentsCountViolations,
    @required this.averageMaintainabilityIndex,
    @required this.totalMaintainabilityIndexViolations,
    @required this.averageMethodsCount,
    @required this.totalMethodsCountViolations,
    @required this.totalCyclomaticComplexity,
    @required this.totalCyclomaticComplexityViolations,
    @required this.totalLinesOfExecutableCode,
    @required this.totalLinesOfExecutableCodeViolations,
  });
}
