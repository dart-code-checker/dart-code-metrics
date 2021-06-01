import 'dart:io';

import '../../../../../reporters/models/console_reporter.dart';
import '../../../metrics/metric_utils.dart';
import '../../../metrics/models/metric_value.dart';
import '../../../metrics/models/metric_value_level.dart';
import '../../../models/lint_file_report.dart';
import '../../utility_selector.dart';
import 'lint_console_reporter_helper.dart';

class LintConsoleReporter extends ConsoleReporter<LintFileReport> {
  /// If true will report info about all files even if they're not above warning threshold
  final bool reportAll;

  final _helper = LintConsoleReporterHelper();

  LintConsoleReporter(IOSink output, {this.reportAll = false}) : super(output);

  @override
  Future<void> report(Iterable<LintFileReport> records) async {
    if (records.isEmpty) {
      return;
    }

    for (final analysisRecord in records) {
      final lines = [
        ..._reportClassMetrics(analysisRecord),
        ..._reportFunctionMetrics(analysisRecord),
      ];

      for (final antiPattern in analysisRecord.antiPatternCases) {
        final severity = _helper.getSeverityForAntiPattern();

        lines.add(_helper.getIssueMessage(antiPattern, severity));
      }

      for (final issue in analysisRecord.issues) {
        final severity = _helper.getSeverity(issue.severity);

        lines.add(_helper.getIssueMessage(issue, severity));
      }

      if (lines.isNotEmpty) {
        output.writeln('${analysisRecord.relativePath}:');
        lines.forEach(output.writeln);
        output.writeln('');
      }
    }
  }

  Iterable<String> _reportClassMetrics(LintFileReport record) {
    final lines = <String>[];

    record.classes.forEach((source, classMetricReport) {
      final report = UtilitySelector.classMetricsReport(classMetricReport);
      final violationLevel = UtilitySelector.classMetricViolationLevel(report);

      if (reportAll || isReportLevel(violationLevel)) {
        final violations = [
          if (reportAll || _isNeedToReport(report.methodsCount))
            _helper.getMetricReport(report.methodsCount, 'number of methods'),
        ];

        lines.add(_helper.getMetricMessage(violationLevel, source, violations));
      }
    });

    return lines;
  }

  Iterable<String> _reportFunctionMetrics(LintFileReport record) {
    final lines = <String>[];

    record.functions.forEach((source, functionReport) {
      final report = UtilitySelector.functionMetricsReport(functionReport);
      final violationLevel =
          UtilitySelector.functionMetricViolationLevel(report);

      if (reportAll || isReportLevel(violationLevel)) {
        final violations = [
          if (reportAll || _isNeedToReport(report.cyclomaticComplexity))
            _helper.getMetricReport(
              report.cyclomaticComplexity,
              'cyclomatic complexity',
            ),
          if (reportAll || _isNeedToReport(report.sourceLinesOfCode))
            _helper.getMetricReport(
              report.sourceLinesOfCode,
              'source lines of code',
            ),
          if (reportAll || _isNeedToReport(report.maintainabilityIndex))
            _helper.getMetricReport(
              report.maintainabilityIndex,
              'maintainability index',
            ),
          if (reportAll || _isNeedToReport(report.argumentsCount))
            _helper.getMetricReport(
              report.argumentsCount,
              'number of arguments',
            ),
          if (reportAll || _isNeedToReport(report.maximumNestingLevel))
            _helper.getMetricReport(
              report.maximumNestingLevel,
              'nesting level',
            ),
        ];

        lines.add(_helper.getMetricMessage(violationLevel, source, violations));
      }
    });

    return lines;
  }

  bool _isNeedToReport(MetricValue metric) =>
      metric.level != MetricValueLevel.none;
}
