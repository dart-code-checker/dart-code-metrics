import 'dart:convert';

import 'package:dart_code_metrics/src/models/config.dart';
import 'package:dart_code_metrics/src/models/file_record.dart';
import 'package:dart_code_metrics/src/reporters/code_climate/code_climate_issue.dart';
import 'package:dart_code_metrics/src/reporters/reporter.dart';
import 'package:dart_code_metrics/src/reporters/utility_selector.dart';
import 'package:meta/meta.dart';

/// Creates reports in Codeclimate format widely understood by various CI and analysis tools
// Code Climate Engine Specification https://github.com/codeclimate/platform/blob/master/spec/analyzers/SPEC.md
class CodeClimateReporter implements Reporter {
  final Config reportConfig;
  CodeClimateReporter({@required this.reportConfig});

  @override
  Iterable<String> report(Iterable<FileRecord> records) =>
      (records?.isNotEmpty ?? false)
          ? [json.encode(records.map(_toIssues).expand((r) => r).toList())]
          : [];

  Iterable<CodeClimateIssue> _toIssues(FileRecord record) {
    final result = <CodeClimateIssue>[];

    for (final key in record.functions.keys) {
      final func = record.functions[key];
      final report = UtilitySelector.functionReport(func, reportConfig);

      if (UtilitySelector.isIssueLevel(
          report.cyclomaticComplexity.violationLevel)) {
        result.add(CodeClimateIssue.cyclomaticComplexity(
            func.firstLine,
            func.lastLine,
            report.cyclomaticComplexity.value,
            record.relativePath,
            key,
            reportConfig.cyclomaticComplexityWarningLevel));
      }

      if (UtilitySelector.isIssueLevel(report.linesOfCode.violationLevel)) {
        result.add(CodeClimateIssue.linesOfCode(
            func.firstLine,
            func.lastLine,
            report.linesOfCode.value,
            record.relativePath,
            key,
            reportConfig.linesOfCodeWarningLevel));
      }

      if (UtilitySelector.isIssueLevel(
          report.maintainabilityIndex.violationLevel)) {
        result.add(CodeClimateIssue.maintainabilityIndex(
            func.firstLine,
            func.lastLine,
            report.maintainabilityIndex.value.toInt(),
            record.relativePath,
            key));
      }

      if (UtilitySelector.isIssueLevel(report.argumentsCount.violationLevel)) {
        result.add(CodeClimateIssue.numberOfArguments(
            func.firstLine,
            func.lastLine,
            report.argumentsCount.value,
            record.relativePath,
            key,
            reportConfig.numberOfArgumentsWarningLevel));
      }
    }

    result.addAll(record.issues.map(
        (issue) => CodeClimateIssue.fromCodeIssue(issue, record.relativePath)));

    return result;
  }
}
