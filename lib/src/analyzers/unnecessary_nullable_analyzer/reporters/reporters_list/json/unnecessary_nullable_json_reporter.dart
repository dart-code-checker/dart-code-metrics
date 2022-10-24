import 'dart:convert';
import 'dart:io';

import '../../../../../reporters/models/json_reporter.dart';
import '../../../models/unnecessary_nullable_file_report.dart';
import '../../../models/unnecessary_nullable_issue.dart';
import '../../unnecessary_nullable_report_params.dart';

/// Unnecessary nullable JSON reporter.
///
/// Use it to create reports in JSON format.
class UnnecessaryNullableJsonReporter extends JsonReporter<
    UnnecessaryNullableFileReport, UnnecessaryNullableReportParams> {
  const UnnecessaryNullableJsonReporter(IOSink output) : super(output, 2);

  @override
  Future<void> report(
    Iterable<UnnecessaryNullableFileReport> records, {
    UnnecessaryNullableReportParams? additionalParams,
  }) async {
    if (records.isEmpty) {
      return;
    }

    final encodedReport = json.encode({
      'formatVersion': formatVersion,
      'timestamp': getTimestamp(),
      'unnecessaryNullable':
          records.map(_unnecessaryNullableFileReportToJson).toList(),
    });

    output.write(encodedReport);
  }

  Map<String, Object> _unnecessaryNullableFileReportToJson(
    UnnecessaryNullableFileReport report,
  ) =>
      {
        'path': report.relativePath,
        'issues': report.issues.map(_issueToJson).toList(),
      };

  Map<String, Object> _issueToJson(UnnecessaryNullableIssue issue) => {
        'declarationType': issue.declarationType,
        'declarationName': issue.declarationName,
        'parameters': issue.parameters.toList(),
        'column': issue.location.column,
        'line': issue.location.line,
        'offset': issue.location.offset,
      };
}
