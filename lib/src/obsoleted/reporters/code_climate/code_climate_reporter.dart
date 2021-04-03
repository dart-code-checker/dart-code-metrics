import 'dart:convert';

import '../../../utils/metric_utils.dart';
import '../../config/config.dart';
import '../../models/file_record.dart';
import '../reporter.dart';
import '../utility_selector.dart';
import 'code_climate_issue.dart';

/// Creates reports in Code Climate format widely understood by various CI and analysis tools
// Code Climate Engine Specification https://github.com/codeclimate/platform/blob/master/spec/analyzers/SPEC.md
class CodeClimateReporter implements Reporter {
  final Config reportConfig;

  /// If true will report in GitLab Code Quality format
  final bool gitlabCompatible;

  CodeClimateReporter({
    required this.reportConfig,
    this.gitlabCompatible = false,
  });

  @override
  Future<Iterable<String>> report(Iterable<FileRecord>? records) async {
    if (records != null && records.isNotEmpty) {
      return gitlabCompatible
          ? [json.encode(records.map(_toIssues).expand((r) => r).toList())]
          : records
              .map(_toIssues)
              .expand((r) => r)
              .map((issue) => '${json.encode(issue)}\x00')
              .toList();
    }

    return [];
  }

  Iterable<CodeClimateIssue> _toIssues(FileRecord record) {
    final result = <CodeClimateIssue>[
      ...record.classes.keys.expand((key) {
        final component = record.classes[key]!;
        final report = UtilitySelector.componentReport(component, reportConfig);

        return [
          if (isReportLevel(report.methodsCount.level))
            CodeClimateIssue.numberOfMethods(
              component.location.start.line,
              component.location.end.line,
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
      final func = record.functions[key]!;
      final report = UtilitySelector.functionReport(func, reportConfig);

      if (isReportLevel(report.cyclomaticComplexity.level)) {
        issues.add(CodeClimateIssue.cyclomaticComplexity(
          func,
          report.cyclomaticComplexity.value,
          record.relativePath,
          key,
          reportConfig.cyclomaticComplexityWarningLevel,
        ));
      }

      if (isReportLevel(report.maintainabilityIndex.level)) {
        issues.add(CodeClimateIssue.maintainabilityIndex(
          func,
          report.maintainabilityIndex.value.toInt(),
          record.relativePath,
          key,
        ));
      }

      if (isReportLevel(report.maximumNestingLevel.level)) {
        issues.add(CodeClimateIssue.maximumNestingLevel(
          func,
          report.maximumNestingLevel.value,
          record.relativePath,
          key,
          reportConfig.maximumNestingWarningLevel,
        ));
      }
    }

    return issues;
  }
}
