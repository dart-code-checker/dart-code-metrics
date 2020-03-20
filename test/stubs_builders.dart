import 'package:dart_code_metrics/src/models/function_report.dart';
import 'package:dart_code_metrics/src/models/violation_level.dart';

FunctionReport buildFunctionReportStub(
        {int cyclomaticComplexity = 0,
        ViolationLevel cyclomaticComplexityViolationLevel = ViolationLevel.none,
        int linesOfCode = 0,
        ViolationLevel linesOfCodeViolationLevel = ViolationLevel.none,
        double maintainabilityIndex = 0,
        ViolationLevel maintainabilityIndexViolationLevel =
            ViolationLevel.none}) =>
    FunctionReport(
        cyclomaticComplexity: cyclomaticComplexity,
        cyclomaticComplexityViolationLevel: cyclomaticComplexityViolationLevel,
        linesOfCode: linesOfCode,
        linesOfCodeViolationLevel: linesOfCodeViolationLevel,
        maintainabilityIndex: maintainabilityIndex,
        maintainabilityIndexViolationLevel: maintainabilityIndexViolationLevel);
