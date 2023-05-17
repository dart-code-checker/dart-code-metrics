import 'dart:io';

import '../../../reporters/models/console_reporter.dart';
import '../../../reporters/models/json_reporter.dart';
import '../../../reporters/models/reporter.dart';
import '../models/unused_code_file_report.dart';
import 'reporters_list/console/unused_code_console_reporter.dart';
import 'reporters_list/json/unused_code_json_reporter.dart';
import 'unused_code_report_params.dart';

final _implementedReports = <String,
    Reporter<UnusedCodeFileReport, UnusedCodeReportParams> Function(
  IOSink output,
)>{
  ConsoleReporter.id: UnusedCodeConsoleReporter.new,
  JsonReporter.id: UnusedCodeJsonReporter.new,
};

Reporter<UnusedCodeFileReport, UnusedCodeReportParams>? reporter({
  required String name,
  required IOSink output,
}) {
  final constructor = _implementedReports[name];

  return constructor != null ? constructor(output) : null;
}
