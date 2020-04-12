import 'dart:convert';

import 'package:dart_code_metrics/src/models/component_record.dart';
import 'package:dart_code_metrics/src/models/config.dart';
import 'package:dart_code_metrics/src/reporters/code_climate/code_climate_issue.dart';
import 'package:dart_code_metrics/src/reporters/reporter.dart';
import 'package:dart_code_metrics/src/reporters/utility_selector.dart';
import 'package:meta/meta.dart';

/// Creates reports in Codeclimate format widely understood by various CI and analysis tools
class CodeClimateReporter implements Reporter {
  final Config reportConfig;
  CodeClimateReporter({@required this.reportConfig});

  @override
  Iterable<String> report(Iterable<ComponentRecord> records) =>
      (records?.isNotEmpty ?? false)
          ? [json.encode(records.map(_toIssues).expand((r) => r).toList())]
          : [];

  Iterable<CodeClimateIssue> _toIssues(ComponentRecord record) {
    final result = <CodeClimateIssue>[];

    for (final key in record.records.keys) {
      final func = record.records[key];
      final report = UtilitySelector.functionReport(func, reportConfig);

      if (UtilitySelector.isIssueLevel(report.linesOfCodeViolationLevel)) {
        result.add(CodeClimateIssue.linesOfCode(
            func.firstLine,
            func.lastLine,
            func.linesWithCode.length,
            record.relativePath,
            key,
            reportConfig.linesOfCodeWarningLevel));
      }

      if (UtilitySelector.isIssueLevel(report.cyclomaticComplexity)) {
        result.add(CodeClimateIssue.cyclomaticComplexity(
            func.firstLine,
            func.lastLine,
            report.cyclomaticComplexity.value,
            record.relativePath,
            key,
            reportConfig.cyclomaticComplexityWarningLevel));
      }

      if (UtilitySelector.isIssueLevel(
          report.maintainabilityIndexViolationLevel)) {
        result.add(CodeClimateIssue.maintainabilityIndex(
            func.firstLine,
            func.lastLine,
            report.maintainabilityIndex.toInt(),
            record.relativePath,
            key));
      }

      if (UtilitySelector.isIssueLevel(report.argumentsCountViolationLevel)) {
        result.add(CodeClimateIssue.numberOfArguments(
            func.firstLine,
            func.lastLine,
            func.argumentsCount,
            record.relativePath,
            key,
            reportConfig.numberOfArgumentsWarningLevel));
      }
    }

    return result;
  }
}
