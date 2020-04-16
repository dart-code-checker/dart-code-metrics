import 'package:dart_code_metrics/src/models/function_record.dart';
import 'package:dart_code_metrics/src/models/function_report.dart';
import 'package:dart_code_metrics/src/models/function_report_metric.dart';
import 'package:dart_code_metrics/src/models/violation_level.dart';

FunctionRecord buildFunctionRecordStub(
        {int firstLine = 0,
        int lastLine = 0,
        int argumentsCount = 0,
        Map<int, int> cyclomaticLinesComplexity = const <int, int>{},
        Iterable<int> linesWithCode = const <int>[],
        Map<int, int> operators = const <int, int>{},
        Map<int, int> operands = const <int, int>{}}) =>
    FunctionRecord(
      firstLine: firstLine,
      lastLine: lastLine,
      argumentsCount: argumentsCount,
      cyclomaticComplexityLines: Map.unmodifiable(cyclomaticLinesComplexity),
      linesWithCode: linesWithCode,
      operators: Map.unmodifiable(operators),
      operands: Map.unmodifiable(operands),
    );

FunctionReport buildFunctionReportStub(
        {int cyclomaticComplexity = 0,
        ViolationLevel cyclomaticComplexityViolationLevel = ViolationLevel.none,
        int linesOfCode = 0,
        ViolationLevel linesOfCodeViolationLevel = ViolationLevel.none,
        double maintainabilityIndex = 0,
        ViolationLevel maintainabilityIndexViolationLevel = ViolationLevel.none,
        int argumentsCount = 0,
        ViolationLevel argumentsCountViolationLevel = ViolationLevel.none}) =>
    FunctionReport(
        cyclomaticComplexity: FunctionReportMetric<int>(
            value: cyclomaticComplexity,
            violationLevel: cyclomaticComplexityViolationLevel),
        linesOfCode: FunctionReportMetric<int>(
            value: linesOfCode, violationLevel: linesOfCodeViolationLevel),
        maintainabilityIndex: FunctionReportMetric<double>(
            value: maintainabilityIndex,
            violationLevel: maintainabilityIndexViolationLevel),
        argumentsCount: FunctionReportMetric<int>(
            value: argumentsCount,
            violationLevel: argumentsCountViolationLevel));
