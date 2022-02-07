import 'dart:io';

import '../../../../unused_code_analyzer.dart';
import '../../../reporters/models/console_reporter.dart';
import '../../../reporters/models/json_reporter.dart';
import '../../../reporters/models/reporter.dart';
import 'unused_code_report_params.dart';

final _implementedReports = <
    String,
    Reporter<UnusedCodeFileReport, void, UnusedCodeReportParams> Function(
  IOSink output,
)>{
  ConsoleReporter.id: (output) => UnusedCodeConsoleReporter(output),
  JsonReporter.id: (output) => UnusedCodeJsonReporter(output),
};

Reporter<UnusedCodeFileReport, void, UnusedCodeReportParams>? reporter({
  required String name,
  required IOSink output,
}) {
  final constructor = _implementedReports[name];

  return constructor != null ? constructor(output) : null;
}
