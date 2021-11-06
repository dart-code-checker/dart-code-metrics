import 'dart:io';

import '../../../../../reporters/models/console_reporter.dart';
import '../../../metrics/metric_utils.dart';
import '../../../metrics/models/metric_value.dart';
import '../../../metrics/models/metric_value_level.dart';
import '../../../models/issue.dart';
import '../../../models/lint_file_report.dart';
import '../../../models/report.dart';
import '../../../models/summary_lint_report_record.dart';
import 'lint_console_reporter_helper.dart';

/// Lint console reporter.
///
/// Use it to create reports in console format.
class LintConsoleReporter
    extends ConsoleReporter<LintFileReport, SummaryLintReportRecord> {
  /// If true will report info about all files even if they're not above warning threshold
  final bool reportAll;

  final _helper = LintConsoleReporterHelper();

  LintConsoleReporter(IOSink output, {this.reportAll = false}) : super(output);

  @override
  Future<void> report(
    Iterable<LintFileReport> records, {
    Iterable<SummaryLintReportRecord> summary = const [],
  }) async {
    if (records.isEmpty) {
      return;
    }

    for (final file in records) {
      final lines = [
        ..._reportMetrics('', file.file),
        ..._reportIssues([...file.issues, ...file.antiPatternCases]),
        ..._reportEntityMetrics({...file.classes, ...file.functions}),
      ];

      if (lines.isNotEmpty) {
        output.writeln('${file.relativePath}:');
        lines.forEach(output.writeln);
        output.writeln('');
      }
    }
  }

  Iterable<String> _reportIssues(Iterable<Issue> issues) => (issues.toList()
        ..sort((a, b) =>
            a.location.start.offset.compareTo(b.location.start.offset)))
      .map(_helper.getIssueMessage);

  Iterable<String> _reportEntityMetrics(Map<String, Report> reports) =>
      (reports.entries.toList()
            ..sort((a, b) => a.value.location.start.offset
                .compareTo(b.value.location.start.offset)))
          .expand((entry) => _reportMetrics(entry.key, entry.value));

  Iterable<String> _reportMetrics(String source, Report report) {
    final reportLevel = report.metricsLevel;
    if (reportAll || isReportLevel(reportLevel)) {
      final violations = [
        for (final metric in report.metrics)
          if (reportAll || _isNeedToReport(metric))
            _helper.getMetricReport(metric),
      ];

      return [
        _helper.getMetricMessage(reportLevel, source, violations),
      ];
    }

    return [];
  }

  bool _isNeedToReport(MetricValue metric) =>
      metric.level > MetricValueLevel.none;
}
