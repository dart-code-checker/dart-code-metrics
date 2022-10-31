import 'package:xml/xml.dart';

import '../../../../../reporters/models/checkstyle_reporter.dart';
import '../../../metrics/models/metric_value_level.dart';
import '../../../models/lint_file_report.dart';
import '../../../models/severity.dart';
import '../../lint_report_params.dart';

/// Lint Checkstyle reporter.
///
/// Use it to create reports in Checkstyle format.
class LintCheckstyleReporter
    extends CheckstyleReporter<LintFileReport, LintReportParams> {
  LintCheckstyleReporter(super.output);

  @override
  Future<void> report(
    Iterable<LintFileReport> records, {
    LintReportParams? additionalParams,
  }) async {
    if (records.isEmpty) {
      return;
    }

    final builder = XmlBuilder();

    builder
      ..processing('xml', 'version="1.0"')
      ..element('checkstyle', attributes: {'version': '10.0'}, nest: () {
        for (final record in records) {
          if (!_needToReport(record)) {
            continue;
          }

          builder.element(
            'file',
            attributes: {'name': record.relativePath},
            nest: () {
              _reportIssues(builder, record);
              _reportMetrics(builder, record);
            },
          );
        }
      });

    output.writeln(builder.buildDocument().toXmlString(pretty: true));
  }

  void _reportIssues(XmlBuilder builder, LintFileReport report) {
    final issues = [...report.issues, ...report.antiPatternCases];

    for (final issue in issues) {
      final locationStart = issue.location.start;
      builder.element(
        'error',
        attributes: {
          'line': '${locationStart.line}',
          if (locationStart.column > 0) 'column': '${locationStart.column}',
          'severity': _issueSeverityMapping[issue.severity] ?? 'ignore',
          'message': issue.message,
          'source': issue.ruleId,
        },
      );
    }
  }

  void _reportMetrics(XmlBuilder builder, LintFileReport record) {
    final metrics = record.file?.metrics;
    if (metrics != null) {
      for (final metric in metrics) {
        if (_isMetricNeedToReport(metric.level)) {
          builder.element(
            'error',
            attributes: {
              'line': '0',
              'severity': _metricSeverityMapping[metric.level] ?? 'ignore',
              'message': metric.comment,
              'source': metric.metricsId,
            },
          );
        }
      }
    }

    final metricRecords =
        {...record.classes, ...record.functions}.entries.toList();
    for (final record in metricRecords) {
      if (!_isMetricNeedToReport(record.value.metricsLevel)) {
        continue;
      }

      final location = record.value.location;

      for (final metricValue in record.value.metrics) {
        builder.element(
          'error',
          attributes: {
            'line': '${location.start.line}',
            if (record.value.location.start.column > 0)
              'column': '${record.value.location.start.column}',
            'severity': _metricSeverityMapping[metricValue.level] ?? 'ignore',
            'message': metricValue.comment,
            'source': metricValue.metricsId,
          },
        );
      }
    }
  }

  bool _needToReport(LintFileReport report) =>
      report.issues.isNotEmpty ||
      report.antiPatternCases.isNotEmpty ||
      (report.file != null && _isMetricNeedToReport(report.file!.metricsLevel));

  bool _isMetricNeedToReport(MetricValueLevel level) =>
      level > MetricValueLevel.none;
}

const _issueSeverityMapping = {
  Severity.error: 'error',
  Severity.warning: 'warning',
  Severity.style: 'info',
  Severity.performance: 'warning',
  Severity.none: 'ignore',
};

const _metricSeverityMapping = {
  MetricValueLevel.alarm: 'error',
  MetricValueLevel.warning: 'warning',
  MetricValueLevel.noted: 'info',
  MetricValueLevel.none: 'ignore',
};
