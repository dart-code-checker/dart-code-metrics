import 'dart:io';

import '../../../reporters/models/console_reporter.dart';
import '../../../reporters/models/json_reporter.dart';
import '../../../reporters/models/reporter.dart';
import '../models/unused_files_file_report.dart';
import 'reporters_list/console/unused_files_console_reporter.dart';
import 'reporters_list/json/unused_files_json_reporter.dart';
import 'unused_files_report_params.dart';

final _implementedReports = <String,
    Reporter<UnusedFilesFileReport, UnusedFilesReportParams> Function(
  IOSink output,
)>{
  ConsoleReporter.id: UnusedFilesConsoleReporter.new,
  JsonReporter.id: UnusedFilesJsonReporter.new,
};

Reporter<UnusedFilesFileReport, UnusedFilesReportParams>? reporter({
  required String name,
  required IOSink output,
}) {
  final constructor = _implementedReports[name];

  return constructor != null ? constructor(output) : null;
}
