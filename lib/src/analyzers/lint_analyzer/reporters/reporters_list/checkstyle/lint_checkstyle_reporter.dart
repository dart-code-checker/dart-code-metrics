import 'dart:io';

import 'package:xml/xml.dart';

import '../../../../../reporters/models/checkstyle_reporter.dart';
import '../../../models/lint_file_report.dart';
import '../../../models/severity.dart';
import '../../../models/summary_lint_report_record.dart';
import '../../lint_report_params.dart';

/// Lint Checkstyle reporter.
///
/// Use it to create reports in Checkstyle format.
class LintCheckstyleReporter extends CheckstyleReporter<LintFileReport,
    SummaryLintReportRecord<Object>, LintReportParams> {
  LintCheckstyleReporter(IOSink output) : super(output);

  @override
  Future<void> report(
    Iterable<LintFileReport> records, {
    Iterable<SummaryLintReportRecord<Object>> summary = const [],
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
              final issues = [...record.issues, ...record.antiPatternCases];

              for (final issue in issues) {
                builder.element(
                  'error',
                  attributes: {
                    'line': '${issue.location.start.line}',
                    if (issue.location.start.column > 0)
                      'column': '${issue.location.start.column}',
                    'severity': _severityMapping[issue.severity] ?? 'ignore',
                    'message': issue.message,
                    'source': issue.ruleId,
                  },
                );
              }
            },
          );
        }
      });

    output.writeln(builder.buildDocument().toXmlString(pretty: true));
  }

  bool _needToReport(LintFileReport report) =>
      report.issues.isNotEmpty || report.antiPatternCases.isNotEmpty;
}

const _severityMapping = {
  Severity.error: 'error',
  Severity.warning: 'warning',
  Severity.style: 'info',
  Severity.performance: 'warning',
  Severity.none: 'ignore',
};
