import 'dart:math';

import 'package:code_checker/metrics.dart';
import 'package:quiver/iterables.dart' as quiver;

import '../config/config.dart';
import '../models/component_record.dart';
import '../models/component_report.dart';
import '../models/file_record.dart';
import '../models/file_report.dart';
import '../models/function_record.dart';
import '../models/function_report.dart';

double log2(num a) => log(a) / ln2;

num sum(Iterable<num> it) => it.fold(0, (a, b) => a + b);

double avg(Iterable<num> it) => it.isNotEmpty ? sum(it) / it.length : 0;

class UtilitySelector {
  static FileReport analysisReportForRecords(
          Iterable<FileRecord> records, Config config) =>
      records.map((r) => fileReport(r, config)).reduce(mergeFileReports);

  static FileReport fileReport(FileRecord record, Config config) {
    final componentReports =
        record.components.values.map((r) => componentReport(r, config));
    final functionReports =
        record.functions.values.map((r) => functionReport(r, config));

    final averageArgumentCount =
        avg(functionReports.map((r) => r.argumentsCount.value));
    final totalArgumentsCountViolations = functionReports
        .where((r) => isIssueLevel(r.argumentsCount.level))
        .length;

    final averageMaintainabilityIndex =
        avg(functionReports.map((r) => r.maintainabilityIndex.value));
    final totalMaintainabilityIndexViolations = functionReports
        .where((r) => isIssueLevel(r.maintainabilityIndex.level))
        .length;

    final averageMethodsCount =
        avg(componentReports.map((r) => r.methodsCount.value));
    final totalMethodsCountViolations = componentReports
        .where((r) => isIssueLevel(r.methodsCount.level))
        .length;

    final totalCyclomaticComplexity =
        sum(functionReports.map((r) => r.cyclomaticComplexity.value));
    final totalCyclomaticComplexityViolations = functionReports
        .where((r) => isIssueLevel(r.cyclomaticComplexity.level))
        .length;

    final totalLinesOfExecutableCode =
        sum(functionReports.map((r) => r.linesOfExecutableCode.value));
    final totalLinesOfExecutableCodeViolations = functionReports
        .where((r) => isIssueLevel(r.linesOfExecutableCode.level))
        .length;

    final averageMaximumNestingLevel =
        avg(functionReports.map((r) => r.maximumNestingLevel.value)).round();
    final totalMaximumNestingLevelViolations = functionReports
        .where((r) => isIssueLevel(r.maximumNestingLevel.level))
        .length;

    return FileReport(
      averageArgumentsCount: averageArgumentCount.round(),
      argumentsCountViolations: totalArgumentsCountViolations,
      averageMaintainabilityIndex: averageMaintainabilityIndex,
      maintainabilityIndexViolations: totalMaintainabilityIndexViolations,
      averageMethodsCount: averageMethodsCount.round(),
      methodsCountViolations: totalMethodsCountViolations,
      totalCyclomaticComplexity: totalCyclomaticComplexity.round(),
      cyclomaticComplexityViolations: totalCyclomaticComplexityViolations,
      totalLinesOfExecutableCode: totalLinesOfExecutableCode.round(),
      linesOfExecutableCodeViolations: totalLinesOfExecutableCodeViolations,
      averageMaximumNestingLevel: averageMaximumNestingLevel,
      maximumNestingLevelViolations: totalMaximumNestingLevelViolations,
    );
  }

  static ComponentReport componentReport(
          ComponentRecord component, Config config) =>
      ComponentReport(
          methodsCount: MetricValue<int>(
        metricsId: '',
        value: component.methodsCount,
        level: valueLevel(
            component.methodsCount, config.numberOfMethodsWarningLevel),
      ));

  static FunctionReport functionReport(FunctionRecord function, Config config) {
    final cyclomaticComplexity =
        sum(function.cyclomaticComplexityLines.values) + 1;

    final linesOfExecutableCode = function.linesWithCode.length;
    final maximumNestingLevel = function.nestingLines.fold<int>(
        0, (previousValue, element) => max(previousValue, element.length));

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
              cyclomaticComplexity * 0.23 -
              16.2 * log(max(1, linesOfExecutableCode))) *
          100 /
          171,
    ).toDouble();

    return FunctionReport(
      cyclomaticComplexity: MetricValue<int>(
        metricsId: '',
        value: cyclomaticComplexity.round(),
        level: valueLevel(
          cyclomaticComplexity.round(),
          config.cyclomaticComplexityWarningLevel,
        ),
      ),
      linesOfExecutableCode: MetricValue<int>(
        metricsId: '',
        value: linesOfExecutableCode,
        level: valueLevel(
            linesOfExecutableCode, config.linesOfExecutableCodeWarningLevel),
      ),
      maintainabilityIndex: MetricValue<double>(
        metricsId: '',
        value: maintainabilityIndex,
        level: _maintainabilityIndexViolationLevel(maintainabilityIndex),
      ),
      argumentsCount: MetricValue<int>(
        metricsId: '',
        value: function.argumentsCount,
        level: valueLevel(
            function.argumentsCount, config.numberOfArgumentsWarningLevel),
      ),
      maximumNestingLevel: MetricValue<int>(
        metricsId: '',
        value: maximumNestingLevel,
        level: valueLevel(
          maximumNestingLevel,
          config.maximumNestingWarningLevel,
        ),
      ),
    );
  }

  static MetricValueLevel componentViolationLevel(ComponentReport report) =>
      report.methodsCount.level;

  static MetricValueLevel functionViolationLevel(FunctionReport report) =>
      quiver.max([
        report.cyclomaticComplexity.level,
        report.linesOfExecutableCode.level,
        report.maintainabilityIndex.level,
        report.argumentsCount.level,
        report.maximumNestingLevel.level,
      ]);

  static bool isIssueLevel(MetricValueLevel level) =>
      level == MetricValueLevel.warning || level == MetricValueLevel.alarm;

  static MetricValueLevel maxViolationLevel(
          Iterable<FileRecord> records, Config config) =>
      quiver.max(records
          .expand((fileRecord) => fileRecord.functions.values
              .map((functionRecord) => functionReport(functionRecord, config)))
          .map(functionViolationLevel));

  static FileReport mergeFileReports(FileReport lhs, FileReport rhs) =>
      FileReport(
        averageArgumentsCount:
            ((lhs.averageArgumentsCount + rhs.averageArgumentsCount) / 2)
                .round(),
        argumentsCountViolations:
            lhs.argumentsCountViolations + rhs.argumentsCountViolations,
        averageMaintainabilityIndex: (lhs.averageMaintainabilityIndex +
                rhs.averageMaintainabilityIndex) /
            2,
        maintainabilityIndexViolations: lhs.maintainabilityIndexViolations +
            rhs.maintainabilityIndexViolations,
        averageMethodsCount:
            ((lhs.averageMethodsCount + rhs.averageMethodsCount) / 2).round(),
        methodsCountViolations:
            lhs.methodsCountViolations + rhs.methodsCountViolations,
        totalCyclomaticComplexity:
            lhs.totalCyclomaticComplexity + rhs.totalCyclomaticComplexity,
        cyclomaticComplexityViolations: lhs.cyclomaticComplexityViolations +
            rhs.cyclomaticComplexityViolations,
        totalLinesOfExecutableCode:
            lhs.totalLinesOfExecutableCode + rhs.totalLinesOfExecutableCode,
        linesOfExecutableCodeViolations: lhs.linesOfExecutableCodeViolations +
            rhs.linesOfExecutableCodeViolations,
        averageMaximumNestingLevel:
            ((lhs.averageMaximumNestingLevel + rhs.averageMaximumNestingLevel) /
                    2)
                .round(),
        maximumNestingLevelViolations: lhs.maximumNestingLevelViolations +
            rhs.maximumNestingLevelViolations,
      );

  static MetricValueLevel _maintainabilityIndexViolationLevel(double index) {
    if (index < 10) {
      return MetricValueLevel.alarm;
    } else if (index < 20) {
      return MetricValueLevel.warning;
    } else if (index < 40) {
      return MetricValueLevel.noted;
    }

    return MetricValueLevel.none;
  }
}
