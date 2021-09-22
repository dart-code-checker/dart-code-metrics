import 'dart:convert';
import 'dart:io';

import 'package:meta/meta.dart';

import '../../../../../reporters/models/json_reporter.dart';
import '../../../models/unused_files_file_report.dart';

@immutable
class UnusedFilesJsonReporter
    extends JsonReporter<Iterable<UnusedFilesFileReport>> {
  const UnusedFilesJsonReporter(IOSink output) : super(output, 2);

  @override
  Future<void> report(Iterable<UnusedFilesFileReport> report) async {
    if (report.isEmpty) {
      return;
    }

    final nowTime = DateTime.now();
    final reportTime = DateTime(
      nowTime.year,
      nowTime.month,
      nowTime.day,
      nowTime.hour,
      nowTime.minute,
      nowTime.second,
    );

    final encodedReport = json.encode({
      'formatVersion': formatVersion,
      'timestamp': reportTime.toString(),
      'unusedFiles': report.map(_analysisRecordToJson).toList(),
    });

    output.write(encodedReport);
  }

  Map<String, String> _analysisRecordToJson(UnusedFilesFileReport report) => {
        'path': report.relativePath,
      };
}
