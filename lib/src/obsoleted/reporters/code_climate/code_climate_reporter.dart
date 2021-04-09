import 'dart:convert';
import 'dart:io';

import '../../../config/config.dart';
import '../../../metrics/cyclomatic_complexity/cyclomatic_complexity_metric.dart';
import '../../../metrics/maximum_nesting_level/maximum_nesting_level_metric.dart';
import '../../../metrics/number_of_methods_metric.dart';
import '../../../models/file_report.dart';
import '../../../reporters/reporter.dart';
import '../../../utils/metric_utils.dart';
import '../utility_selector.dart';
import 'code_climate_issue.dart';

/// Creates reports in Code Climate format widely understood by various CI and analysis tools
// Code Climate Engine Specification https://github.com/codeclimate/platform/blob/master/spec/analyzers/SPEC.md
class CodeClimateReporter implements Reporter {
  final IOSink _output;

  final Config reportConfig;

  /// If true will report in GitLab Code Quality format
  final bool gitlabCompatible;

  CodeClimateReporter(
    this._output, {
    required this.reportConfig,
    this.gitlabCompatible = false,
  });

  @override
  Future<void> report(Iterable<FileReport> records) async {
    if (records.isEmpty) {
      return;
    }

    return gitlabCompatible
        ? _output.writeln(
            json.encode(records.map(_toIssues).expand((r) => r).toList()),
          )
        : records.map(_toIssues).expand((r) => r).forEach((issue) {
            _output.writeln('${json.encode(issue)}\x00');
          });
  }

  Iterable<CodeClimateIssue> _toIssues(FileReport record) {
    final result = <CodeClimateIssue>[
      ...record.classes.keys.expand((key) {
        final component = record.classes[key]!;
        final report = UtilitySelector.componentReport(component);

        return [
          if (isReportLevel(report.methodsCount.level))
            CodeClimateIssue.numberOfMethods(
              component.location.start.line,
              component.location.end.line,
              report.methodsCount.value,
              record.relativePath,
              key,
              readThreshold<int>(
                reportConfig.metrics,
                NumberOfMethodsMetric.metricId,
                10,
              ),
            ),
        ];
      }),
    ];

    return result
      ..addAll(_functionMetrics(record))
      ..addAll(record.issues.map((issue) =>
          CodeClimateIssue.fromCodeIssue(issue, record.relativePath)))
      ..addAll(record.antiPatternCases.map((antiPattern) =>
          CodeClimateIssue.fromDesignIssue(antiPattern, record.relativePath)));
  }

  Iterable<CodeClimateIssue> _functionMetrics(FileReport record) {
    final issues = <CodeClimateIssue>[];

    for (final key in record.functions.keys) {
      final func = record.functions[key]!;
      final report = UtilitySelector.functionReport(func);

      if (isReportLevel(report.cyclomaticComplexity.level)) {
        issues.add(CodeClimateIssue.cyclomaticComplexity(
          func,
          report.cyclomaticComplexity.value,
          record.relativePath,
          key,
          readThreshold<int>(
            reportConfig.metrics,
            CyclomaticComplexityMetric.metricId,
            20,
          ),
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
          readThreshold<int>(
            reportConfig.metrics,
            MaximumNestingLevelMetric.metricId,
            5,
          ),
        ));
      }
    }

    return issues;
  }
}
