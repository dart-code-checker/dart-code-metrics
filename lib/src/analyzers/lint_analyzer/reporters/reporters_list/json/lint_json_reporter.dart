import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';
import 'package:source_span/source_span.dart';

import '../../../../../reporters/models/json_reporter.dart';
import '../../../metrics/models/metric_value.dart';
import '../../../models/context_message.dart';
import '../../../models/issue.dart';
import '../../../models/lint_file_report.dart';
import '../../../models/replacement.dart';
import '../../../models/report.dart';
import '../../../models/summary_lint_report_record.dart';
import '../../lint_report_params.dart';

/// Lint JSON reporter.
///
/// Use it to create reports in JSON format.
class LintJsonReporter extends JsonReporter<LintFileReport, LintReportParams> {
  const LintJsonReporter(IOSink output) : super(output, 2);

  factory LintJsonReporter.toFile(String path, String rootFolder) {
    final isAbsolutePath = isAbsolute(path);
    final filePath = isAbsolutePath ? path : normalize(join(rootFolder, path));

    final file = File(filePath.endsWith('.json') ? filePath : '$filePath.json');

    return LintJsonReporter(file.openWrite());
  }

  @override
  Future<void> report(
    Iterable<LintFileReport> records, {
    LintReportParams? additionalParams,
  }) async {
    if (records.isEmpty) {
      return;
    }

    final summary = additionalParams?.summary;

    final encodedReport = json.encode({
      'formatVersion': formatVersion,
      'timestamp': getTimestamp(),
      'records': records.map(_lintFileReportToJson).toList(),
      if (summary != null && summary.isNotEmpty)
        'summary': summary.map(_summaryLintReportRecordToJson).toList(),
    });

    output.write(encodedReport);
  }

  Map<String, Object> _lintFileReportToJson(LintFileReport report) => {
        'path': report.relativePath,
        'fileMetrics': _metricValuesToJson(report.file?.metrics),
        'classes': _reportToJson(report.classes),
        'functions': _reportToJson(report.functions),
        'issues': _issueToJson(report.issues),
        'antiPatternCases': _issueToJson(report.antiPatternCases),
      };

  Map<String, Object> _summaryLintReportRecordToJson(
    SummaryLintReportRecord<Object> record,
  ) {
    final recordValue = record.value;

    return {
      'status': record.status.toString(),
      'title': record.title,
      'value': recordValue is Iterable ? recordValue.toList() : recordValue,
      'violations': record.violations,
    };
  }

  Map<String, Map<String, Object>> _reportToJson(Map<String, Report> reports) =>
      reports.map((key, value) => MapEntry(key, {
            'codeSpan': _sourceSpanToJson(value.location),
            'metrics': _metricValuesToJson(value.metrics),
          }));

  List<Map<String, Object>> _issueToJson(Iterable<Issue> issues) =>
      issues.map((issue) {
        final suggestion = issue.suggestion;
        final verboseMessage = issue.verboseMessage;

        return {
          'ruleId': issue.ruleId,
          'documentation': issue.documentation.toString(),
          'codeSpan': _sourceSpanToJson(issue.location),
          'severity': issue.severity.toString(),
          'message': issue.message,
          if (verboseMessage != null && verboseMessage.isNotEmpty)
            'verboseMessage': verboseMessage,
          if (suggestion != null) 'suggestion': _reportReplacement(suggestion),
        };
      }).toList();

  Map<String, Object> _sourceSpanToJson(SourceSpan location) => {
        'start': _sourceLocationToJson(location.start),
        'end': _sourceLocationToJson(location.end),
        'text': location.text,
      };

  List<Map<String, Object>> _metricValuesToJson(
    Iterable<MetricValue>? metrics,
  ) =>
      (metrics ?? []).map((metric) {
        final unitType = metric.unitType;
        final recommendation = metric.recommendation;

        return {
          'metricsId': metric.metricsId,
          'value': metric.value,
          if (unitType != null) 'unitType': unitType,
          'level': metric.level.toString(),
          'comment': metric.comment,
          if (recommendation != null) 'recommendation': recommendation,
          'context': _contextMessagesToJson(metric.context),
        };
      }).toList();

  Map<String, Object> _sourceLocationToJson(SourceLocation location) => {
        'offset': location.offset,
        'line': location.line,
        'column': location.column,
      };

  List<Map<String, Object>> _contextMessagesToJson(
    Iterable<ContextMessage> messages,
  ) =>
      messages
          .map((message) => {
                'message': message.message,
                'codeSpan': _sourceSpanToJson(message.location),
              })
          .toList();

  Map<String, String> _reportReplacement(Replacement replacement) => {
        'comment': replacement.comment,
        'replacement': replacement.replacement,
      };
}
