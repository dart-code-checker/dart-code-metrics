import 'dart:io';

import '../../../reporters/models/console_reporter.dart';
import '../../../reporters/models/json_reporter.dart';
import '../../../reporters/models/reporter.dart';
import '../models/unnecessary_nullable_file_report.dart';
import 'reporters_list/console/unnecessary_nullable_console_reporter.dart';
import 'reporters_list/json/unnecessary_nullable_json_reporter.dart';
import 'unnecessary_nullable_report_params.dart';

final _implementedReports = <String,
    Reporter<UnnecessaryNullableFileReport, UnnecessaryNullableReportParams>
        Function(
  IOSink output,
)>{
  ConsoleReporter.id: UnnecessaryNullableConsoleReporter.new,
  JsonReporter.id: UnnecessaryNullableJsonReporter.new,
};

Reporter<UnnecessaryNullableFileReport, UnnecessaryNullableReportParams>?
    reporter({
  required String name,
  required IOSink output,
}) {
  final constructor = _implementedReports[name];

  return constructor != null ? constructor(output) : null;
}
