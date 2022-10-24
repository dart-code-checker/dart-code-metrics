import 'dart:convert';
import 'dart:io';

import '../../../../../reporters/models/json_reporter.dart';
import '../../../models/unused_files_file_report.dart';
import '../../unused_files_report_params.dart';

/// Unused files JSON reporter.
///
/// Use it to create reports in JSON format.
class UnusedFilesJsonReporter
    extends JsonReporter<UnusedFilesFileReport, UnusedFilesReportParams> {
  const UnusedFilesJsonReporter(IOSink output) : super(output, 2);

  @override
  Future<void> report(
    Iterable<UnusedFilesFileReport> records, {
    UnusedFilesReportParams? additionalParams,
  }) async {
    if (records.isEmpty) {
      return;
    }

    final encodedReport = json.encode({
      'formatVersion': formatVersion,
      'timestamp': getTimestamp(),
      'unusedFiles': records.map(_analysisRecordToJson).toList(),
      'automaticallyDeleted': additionalParams?.deleteUnusedFiles ?? false,
    });

    output.write(encodedReport);
  }

  Map<String, String> _analysisRecordToJson(UnusedFilesFileReport report) =>
      {'path': report.relativePath};
}
