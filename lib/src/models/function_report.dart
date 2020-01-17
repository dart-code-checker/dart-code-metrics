import 'package:meta/meta.dart';
import 'package:metrics/src/models/violation_level.dart';

@immutable
class FunctionReport {
  final int cyclomaticComplexity;
  final ViolationLevel cyclomaticComplexityViolationLevel;

  final int linesOfCode;
  final ViolationLevel linesOfCodeViolationLevel;

  final double maintainabilityIndex;
  final ViolationLevel maintainabilityIndexViolationLevel;

  const FunctionReport(
      {@required this.cyclomaticComplexity,
      @required this.cyclomaticComplexityViolationLevel,
      @required this.linesOfCode,
      @required this.linesOfCodeViolationLevel,
      @required this.maintainabilityIndex,
      @required this.maintainabilityIndexViolationLevel});
}
