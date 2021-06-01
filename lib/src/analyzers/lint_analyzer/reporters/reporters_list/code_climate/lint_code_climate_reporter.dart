import 'dart:convert';
import 'dart:io';

import '../../../../../reporters/models/code_climate_reporter.dart';
import '../../../metrics/metric_utils.dart';
import '../../../metrics/metrics_list/cyclomatic_complexity/cyclomatic_complexity_metric.dart';
import '../../../metrics/metrics_list/maximum_nesting_level/maximum_nesting_level_metric.dart';
import '../../../metrics/metrics_list/number_of_methods_metric.dart';
import '../../../models/lint_file_report.dart';
import '../../utility_selector.dart';
import 'code_climate_issue.dart';

class LintCodeClimateReporter extends CodeClimateReporter<LintFileReport> {
  final Map<String, Object> metrics;

  LintCodeClimateReporter(
    IOSink output, {
    required this.metrics,
    bool gitlabCompatible = false,
  }) : super(
          output,
          gitlabCompatible: gitlabCompatible,
        );

  @override
  Future<void> report(Iterable<LintFileReport> records) async {
    if (records.isEmpty) {
      return;
    }

    final codeClimateRecords = records.map(_toIssues).expand((r) => r);

    if (gitlabCompatible) {
      output.writeln(json.encode(codeClimateRecords.toList()));
    } else {
      for (final record in codeClimateRecords) {
        output.writeln('${json.encode(record)}\x00');
      }
    }
  }

  Iterable<CodeClimateIssue> _toIssues(LintFileReport record) {
    final result = <CodeClimateIssue>[
      ...record.classes.keys.expand((key) {
        final component = record.classes[key]!;
        final report = UtilitySelector.classMetricsReport(component);

        return [
          if (isReportLevel(report.methodsCount.level))
            CodeClimateIssue.numberOfMethods(
              component.location.start.line,
              component.location.end.line,
              report.methodsCount.value,
              record.relativePath,
              key,
              readThreshold<int>(
                metrics,
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

  Iterable<CodeClimateIssue> _functionMetrics(LintFileReport record) {
    final issues = <CodeClimateIssue>[];

    for (final key in record.functions.keys) {
      final func = record.functions[key]!;
      final report = UtilitySelector.functionMetricsReport(func);

      if (isReportLevel(report.cyclomaticComplexity.level)) {
        issues.add(CodeClimateIssue.cyclomaticComplexity(
          func,
          report.cyclomaticComplexity.value,
          record.relativePath,
          key,
          readThreshold<int>(
            metrics,
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
            metrics,
            MaximumNestingLevelMetric.metricId,
            5,
          ),
        ));
      }
    }

    return issues;
  }
}
