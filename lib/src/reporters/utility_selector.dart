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

class UtilitySelector {
  static ComponentReport analysisReportForRecords(
      Iterable<ComponentRecord> records, Config config) {
    final report = records.fold<ComponentReport>(ComponentReport.empty(),
        (prevValue, record) {
      final report = componentReport(record, config);

      return ComponentReport(
          averageArgumentsCount:
              prevValue.averageArgumentsCount + report.averageArgumentsCount,
          totalArgumentsCountViolations:
              prevValue.totalArgumentsCountViolations +
                  report.totalArgumentsCountViolations,
          averageMaintainabilityIndex: prevValue.averageMaintainabilityIndex +
              report.averageMaintainabilityIndex,
          totalMaintainabilityIndexViolations:
              prevValue.totalMaintainabilityIndexViolations +
                  report.totalMaintainabilityIndexViolations,
          totalCyclomaticComplexity: prevValue.totalCyclomaticComplexity +
              report.totalCyclomaticComplexity,
          totalCyclomaticComplexityViolations:
              prevValue.totalCyclomaticComplexityViolations +
                  report.totalCyclomaticComplexityViolations,
          totalLinesOfCode:
              prevValue.totalLinesOfCode + report.totalLinesOfCode,
          totalLinesOfCodeViolations: prevValue.totalLinesOfCodeViolations +
              report.totalLinesOfCodeViolations);
    });

    return ComponentReport(
        averageArgumentsCount:
            (report.averageArgumentsCount / records.length).round(),
        totalArgumentsCountViolations: report.totalArgumentsCountViolations,
        averageMaintainabilityIndex:
            report.averageMaintainabilityIndex / records.length,
        totalMaintainabilityIndexViolations:
            report.totalMaintainabilityIndexViolations,
        totalCyclomaticComplexity: report.totalCyclomaticComplexity,
        totalCyclomaticComplexityViolations:
            report.totalCyclomaticComplexityViolations,
        totalLinesOfCode: report.totalLinesOfCode,
        totalLinesOfCodeViolations: report.totalLinesOfCodeViolations);
  }

  static ComponentReport componentReport(
      ComponentRecord record, Config config) {
    var totalCyclomaticComplexity = 0;
    var totalCyclomaticComplexityViolations = 0;
    var totalLinesOfCode = 0;
    var totalLinesOfCodeViolations = 0;
    var averageMaintainabilityIndex = 0.0;
    var totalMaintainabilityIndexViolations = 0;
    var totalArgumentsCount = 0;
    var totalArgumentsCountViolations = 0;

    for (final record in record.records.values) {
      final report = functionReport(record, config);

      totalCyclomaticComplexity += report.cyclomaticComplexity.value;
      if (isIssueLevel(report.cyclomaticComplexity.violationLevel)) {
        ++totalCyclomaticComplexityViolations;
      }

      totalLinesOfCode += report.linesOfCode.value;
      if (isIssueLevel(report.linesOfCode.violationLevel)) {
        ++totalLinesOfCodeViolations;
      }

      averageMaintainabilityIndex += report.maintainabilityIndex.value;
      if (isIssueLevel(report.maintainabilityIndex.violationLevel)) {
        ++totalMaintainabilityIndexViolations;
      }

      totalArgumentsCount += report.argumentsCount.value;
      if (isIssueLevel(report.argumentsCount.violationLevel)) {
        ++totalArgumentsCountViolations;
      }
    }

    return ComponentReport(
        averageArgumentsCount:
            (totalArgumentsCount / record.records.values.length).round(),
        totalArgumentsCountViolations: totalArgumentsCountViolations,
        averageMaintainabilityIndex:
            averageMaintainabilityIndex / record.records.values.length,
        totalMaintainabilityIndexViolations:
            totalMaintainabilityIndexViolations,
        totalCyclomaticComplexity: totalCyclomaticComplexity,
        totalCyclomaticComplexityViolations:
            totalCyclomaticComplexityViolations,
        totalLinesOfCode: totalLinesOfCode,
        totalLinesOfCodeViolations: totalLinesOfCodeViolations);
  }

  static FunctionReport functionReport(FunctionRecord function, Config config) {
    final cyclomaticComplexity = function.cyclomaticLinesComplexity.values
            .fold<int>(0, (prevValue, nextValue) => prevValue + nextValue) +
        1;

    final linesOfCode = function.linesWithCode.length;

    // Total number of occurrences of operators.
    final totalNumberOfOccurrencesOfOperators = function.operators.values
        .fold<int>(0, (prevValue, nextValue) => prevValue + nextValue);

    // Total number of occurrences of operands
    final totalNumberOfOccurrencesOfOperands = function.operands.values
        .fold<int>(0, (prevValue, nextValue) => prevValue + nextValue);

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
            value: cyclomaticComplexity,
            violationLevel: _violationLevel(
                cyclomaticComplexity, config.cyclomaticComplexityWarningLevel)),
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

  static ViolationLevel functionViolationLevel(FunctionReport report) {
    final values = ViolationLevel.values.toList();

    final highestLevelIndex = quiver.max([
      report.cyclomaticComplexity.violationLevel,
      report.linesOfCode.violationLevel,
      report.maintainabilityIndex.violationLevel,
      report.argumentsCount.violationLevel,
    ].map(values.indexOf));

    return values.elementAt(highestLevelIndex);
  }

  static bool isIssueLevel(ViolationLevel level) =>
      level == ViolationLevel.warning || level == ViolationLevel.alarm;

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
