import 'dart:convert';

import 'package:meta/meta.dart';

import '../../config/config.dart';
import '../../models/file_record.dart';
import '../reporter.dart';
import '../utility_selector.dart';
import 'code_climate_issue.dart';

/// Creates reports in Code Climate format widely understood by various CI and analysis tools
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
    final result = <CodeClimateIssue>[
      ...record.components.keys.expand((key) {
        final component = record.components[key];
        final report = UtilitySelector.componentReport(component, reportConfig);

        return [
          if (UtilitySelector.isIssueLevel(report.methodsCount.violationLevel))
            CodeClimateIssue.numberOfMethods(
              component.firstLine,
              component.lastLine,
              report.methodsCount.value,
              record.relativePath,
              key,
              reportConfig.numberOfMethodsWarningLevel,
            ),
        ];
      }),
    ];

    return result
      ..addAll(_functionMetrics(record))
      ..addAll(record.issues.map((issue) =>
          CodeClimateIssue.fromCodeIssue(issue, record.relativePath)))
      ..addAll(record.designIssues.map((issue) =>
          CodeClimateIssue.fromDesignIssue(issue, record.relativePath)));
  }

  Iterable<CodeClimateIssue> _functionMetrics(FileRecord record) {
    final issues = <CodeClimateIssue>[];

    for (final key in record.functions.keys) {
      final func = record.functions[key];
      final report = UtilitySelector.functionReport(func, reportConfig);

      if (UtilitySelector.isIssueLevel(
          report.cyclomaticComplexity.violationLevel)) {
        issues.add(CodeClimateIssue.cyclomaticComplexity(
          func,
          report.cyclomaticComplexity.value,
          record.relativePath,
          key,
          reportConfig.cyclomaticComplexityWarningLevel,
        ));
      }

      if (UtilitySelector.isIssueLevel(
          report.maintainabilityIndex.violationLevel)) {
        issues.add(CodeClimateIssue.maintainabilityIndex(
          func,
          report.maintainabilityIndex.value.toInt(),
          record.relativePath,
          key,
        ));
      }
    }

    return issues;
  }
}
