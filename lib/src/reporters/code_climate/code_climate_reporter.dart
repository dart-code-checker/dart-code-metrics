import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:metrics/src/models/component_record.dart';
import 'package:metrics/src/models/config.dart';
import 'package:metrics/src/models/violation_level.dart';
import 'package:metrics/src/reporters/code_climate/code_climate_issue.dart';
import 'package:metrics/src/reporters/reporter.dart';
import 'package:metrics/src/reporters/utility_selector.dart';

class CodeClimateReporter implements Reporter {
  final Config reportConfig;

  CodeClimateReporter({@required this.reportConfig});

  @override
  void report(Iterable<ComponentRecord> records) {
    if (records?.isEmpty ?? true) {
      return;
    }

    final data = records.map(_toIssues).expand((r) => r).toList(growable: false);
    for (final issue in data) {
      print(json.encode(issue));
    }
  }

  bool _isIssueLevel(ViolationLevel level) => level == ViolationLevel.warning || level == ViolationLevel.alarm;

  List<CodeClimateIssue> _toIssues(ComponentRecord record) {
    final result = <CodeClimateIssue>[];
    for (final key in record.records.keys) {
      final func = record.records[key];
      final report = UtilitySelector.functionReport(func, reportConfig);
      if (_isIssueLevel(report.linesOfCodeViolationLevel)) {
        result.add(CodeClimateIssue.linesOfCode(
            func.firstLine, func.lastLine, record.relativePath, key, reportConfig.linesOfCodeWarningLevel));
      }
      if (_isIssueLevel(report.cyclomaticComplexityViolationLevel)) {
        result.add(CodeClimateIssue.cyclomaticComplexity(func.firstLine, func.lastLine, report.cyclomaticComplexity,
            record.relativePath, key, reportConfig.linesOfCodeWarningLevel));
      }
      if (_isIssueLevel(report.maintainabilityIndexViolationLevel)) {
        result.add(CodeClimateIssue.maintainabilityIndex(
            func.firstLine, func.lastLine, report.maintainabilityIndex, record.relativePath, key));
      }
    }
    return result;
  }
}
