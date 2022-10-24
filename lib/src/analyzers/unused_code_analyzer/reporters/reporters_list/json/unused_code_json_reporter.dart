import 'dart:convert';
import 'dart:io';

import '../../../../../reporters/models/json_reporter.dart';
import '../../../models/unused_code_file_report.dart';
import '../../../models/unused_code_issue.dart';
import '../../unused_code_report_params.dart';

/// Unused code JSON reporter.
///
/// Use it to create reports in JSON format.
class UnusedCodeJsonReporter
    extends JsonReporter<UnusedCodeFileReport, UnusedCodeReportParams> {
  const UnusedCodeJsonReporter(IOSink output) : super(output, 2);

  @override
  Future<void> report(
    Iterable<UnusedCodeFileReport> records, {
    UnusedCodeReportParams? additionalParams,
  }) async {
    if (records.isEmpty) {
      return;
    }

    final encodedReport = json.encode({
      'formatVersion': formatVersion,
      'timestamp': getTimestamp(),
      'unusedCode': records.map(_unusedCodeFileReportToJson).toList(),
    });

    output.write(encodedReport);
  }

  Map<String, Object> _unusedCodeFileReportToJson(
    UnusedCodeFileReport report,
  ) =>
      {
        'path': report.relativePath,
        'issues': report.issues.map(_issueToJson).toList(),
      };

  Map<String, Object> _issueToJson(UnusedCodeIssue issue) => {
        'declarationType': issue.declarationType,
        'declarationName': issue.declarationName,
        'column': issue.location.column,
        'line': issue.location.line,
        'offset': issue.location.offset,
      };
}
