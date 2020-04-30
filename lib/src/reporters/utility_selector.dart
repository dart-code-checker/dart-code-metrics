import 'dart:math';

import 'package:dart_code_metrics/src/models/component_record.dart';
import 'package:dart_code_metrics/src/models/component_report.dart';
import 'package:dart_code_metrics/src/models/config.dart';
import 'package:dart_code_metrics/src/models/function_record.dart';
import 'package:dart_code_metrics/src/models/function_report.dart';
import 'package:dart_code_metrics/src/models/function_report_metric.dart';
import 'package:dart_code_metrics/src/models/violation_level.dart';
import 'package:quiver/iterables.dart' as quiver;

double log2(num a) => log(a) / ln2;

num sum(Iterable<num> it) => it.fold(0, (a, b) => a + b);

double avg(Iterable<num> it) => it.isNotEmpty ? sum(it) / it.length : 0;

class UtilitySelector {
  static ComponentReport analysisReportForRecords(
          Iterable<ComponentRecord> records, Config config) =>
      records
          .map((r) => componentReport(r, config))
          .reduce(mergeComponentReports);

  static ComponentReport componentReport(
      ComponentRecord record, Config config) {
    final functionReports =
        record.records.values.map((r) => functionReport(r, config));

    final averageArgumentCount =
        avg(functionReports.map((r) => r.argumentsCount.value));
    final totalArgumentsCountViolations = functionReports
        .where((r) => isIssueLevel(r.argumentsCount.violationLevel))
        .length;

    final averageMaintainabilityIndex =
        avg(functionReports.map((r) => r.maintainabilityIndex.value));
    final totalMaintainabilityIndexViolations = functionReports
        .where((r) => isIssueLevel(r.maintainabilityIndex.violationLevel))
        .length;

    final totalCyclomaticComplexity =
        sum(functionReports.map((r) => r.cyclomaticComplexity.value));
    final totalCyclomaticComplexityViolations = functionReports
        .where((r) => isIssueLevel(r.cyclomaticComplexity.violationLevel))
        .length;

    final totalLinesOfCode =
        sum(functionReports.map((r) => r.linesOfCode.value));
    final totalLinesOfCodeViolations = functionReports
        .where((r) => isIssueLevel(r.linesOfCode.violationLevel))
        .length;

    return ComponentReport(
        averageArgumentsCount: averageArgumentCount.round(),
        totalArgumentsCountViolations: totalArgumentsCountViolations,
        averageMaintainabilityIndex: averageMaintainabilityIndex,
        totalMaintainabilityIndexViolations:
            totalMaintainabilityIndexViolations,
        totalCyclomaticComplexity: totalCyclomaticComplexity.round(),
        totalCyclomaticComplexityViolations:
            totalCyclomaticComplexityViolations,
        totalLinesOfCode: totalLinesOfCode.round(),
        totalLinesOfCodeViolations: totalLinesOfCodeViolations);
  }

  static FunctionReport functionReport(FunctionRecord function, Config config) {
    final cyclomaticComplexity =
        sum(function.cyclomaticLinesComplexity.values) + 1;

    final linesOfCode = function.linesWithCode.length;

    // Total number of occurrences of operators.
    final totalNumberOfOccurrencesOfOperators = sum(function.operators.values);

    // Total number of occurrences of operands
    final totalNumberOfOccurrencesOfOperands = sum(function.operands.values);

    // Number of distinct operators.
    final numberOfDistinctOperators = function.operators.keys.length;

    // Number of distinct operands.
    final numberOfDistinctOperands = function.operands.keys.length;

    // Halstead Program Length – The total number of operator occurrences and the total number of operand occurrences.
    final halsteadProgramLength = totalNumberOfOccurrencesOfOperators +
        totalNumberOfOccurrencesOfOperands;

    // Halstead Vocabulary – The total number of unique operator and unique operand occurrences.
    final halsteadVocabulary =
        numberOfDistinctOperators + numberOfDistinctOperands;

    // Program Volume – Proportional to program size, represents the size, in bits, of space necessary for storing the program. This parameter is dependent on specific algorithm implementation.
    final halsteadVolume =
        halsteadProgramLength * log2(max(1, halsteadVocabulary));

    final maintainabilityIndex = max(
            0,
            (171 -
                    5.2 * log(max(1, halsteadVolume)) -
                    0.23 * cyclomaticComplexity -
                    16.2 * log(max(1, linesOfCode))) *
                100 /
                171)
        .toDouble();

    return FunctionReport(
        cyclomaticComplexity: FunctionReportMetric<int>(
            value: cyclomaticComplexity.round(),
            violationLevel: _violationLevel(cyclomaticComplexity.round(),
                config.cyclomaticComplexityWarningLevel)),
        linesOfCode: FunctionReportMetric<int>(
            value: linesOfCode,
            violationLevel:
                _violationLevel(linesOfCode, config.linesOfCodeWarningLevel)),
        maintainabilityIndex: FunctionReportMetric<double>(
            value: maintainabilityIndex,
            violationLevel:
                _maintainabilityIndexViolationLevel(maintainabilityIndex)),
        argumentsCount: FunctionReportMetric<int>(
            value: function.argumentsCount,
            violationLevel: _violationLevel(function.argumentsCount,
                config.numberOfArgumentsWarningLevel)));
  }

  static ViolationLevel functionViolationLevel(FunctionReport report) =>
      quiver.max([
        report.cyclomaticComplexity.violationLevel,
        report.linesOfCode.violationLevel,
        report.maintainabilityIndex.violationLevel,
        report.argumentsCount.violationLevel,
      ]);

  static bool isIssueLevel(ViolationLevel level) =>
      level == ViolationLevel.warning || level == ViolationLevel.alarm;

  static ViolationLevel maxViolationLevel(
          Iterable<ComponentRecord> records, Config config) =>
      quiver.max(records
          .expand((componentRecord) => componentRecord.records.values.map(
              (functionRecord) =>
                  UtilitySelector.functionReport(functionRecord, config)))
          .map(UtilitySelector.functionViolationLevel));

  static ViolationLevel _violationLevel(int value, int warningLevel) {
    if (value > warningLevel * 2) {
      return ViolationLevel.alarm;
    } else if (value > warningLevel) {
      return ViolationLevel.warning;
    } else if (value > (warningLevel / 2).floor()) {
      return ViolationLevel.noted;
    }

    return ViolationLevel.none;
  }

  static ViolationLevel _maintainabilityIndexViolationLevel(double index) {
    if (index < 10) {
      return ViolationLevel.alarm;
    } else if (index < 20) {
      return ViolationLevel.warning;
    } else if (index < 40) {
      return ViolationLevel.noted;
    }

    return ViolationLevel.none;
  }
}
