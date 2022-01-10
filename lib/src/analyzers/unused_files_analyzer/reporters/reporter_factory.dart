import 'dart:io';

import '../../../reporters/models/console_reporter.dart';
import '../../../reporters/models/json_reporter.dart';
import '../../../reporters/models/reporter.dart';
import '../models/unused_files_file_report.dart';
import 'report_params.dart';
import 'reporters_list/console/unused_files_console_reporter.dart';
import 'reporters_list/json/unused_files_json_reporter.dart';

final _implementedReports = <
    String,
    Reporter<UnusedFilesFileReport, void, ReportParams> Function(
  IOSink output,
)>{
  ConsoleReporter.id: (output) => UnusedFilesConsoleReporter(output),
  JsonReporter.id: (output) => UnusedFilesJsonReporter(output),
};

Reporter<UnusedFilesFileReport, void, ReportParams>? reporter({
  required String name,
  required IOSink output,
}) {
  final constructor = _implementedReports[name];

  return constructor != null ? constructor(output) : null;
}
