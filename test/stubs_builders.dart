import 'package:built_collection/built_collection.dart';
import 'package:dart_code_metrics/src/models/function_record.dart';
import 'package:dart_code_metrics/src/models/function_report.dart';
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
      cyclomaticLinesComplexity: BuiltMap.from(cyclomaticLinesComplexity),
      linesWithCode: linesWithCode,
      operators: BuiltMap.from(operators),
      operands: BuiltMap.from(operands),
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
        cyclomaticComplexity: cyclomaticComplexity,
        cyclomaticComplexityViolationLevel: cyclomaticComplexityViolationLevel,
        linesOfCode: linesOfCode,
        linesOfCodeViolationLevel: linesOfCodeViolationLevel,
        maintainabilityIndex: maintainabilityIndex,
        maintainabilityIndexViolationLevel: maintainabilityIndexViolationLevel,
        argumentsCount: argumentsCount,
        argumentsCountViolationLevel: argumentsCountViolationLevel);
