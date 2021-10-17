import 'dart:convert';
import 'dart:io';

import 'package:meta/meta.dart';

import '../../../../../reporters/models/json_reporter.dart';
import '../../../models/unused_files_file_report.dart';

@immutable
class UnusedFilesJsonReporter
    extends JsonReporter<UnusedFilesFileReport, void> {
  const UnusedFilesJsonReporter(IOSink output) : super(output, 2);

  @override
  Future<void> report(
    Iterable<UnusedFilesFileReport> records, {
    Iterable<void> summary = const [],
  }) async {
    if (records.isEmpty) {
      return;
    }

    final encodedReport = json.encode({
      'formatVersion': formatVersion,
      'timestamp': getTimestamp(),
      'unusedFiles': records.map(_analysisRecordToJson).toList(),
    });

    output.write(encodedReport);
  }

  Map<String, String> _analysisRecordToJson(UnusedFilesFileReport report) => {
        'path': report.relativePath,
      };
}
