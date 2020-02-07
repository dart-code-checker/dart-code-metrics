import 'package:dart_code_metrics/src/models/violation_level.dart';
import 'package:meta/meta.dart';

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
