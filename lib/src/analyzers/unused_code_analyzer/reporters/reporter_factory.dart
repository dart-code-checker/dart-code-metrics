import 'dart:io';

import '../../../../unused_code_analyzer.dart';
import '../../../reporters/models/console_reporter.dart';
import '../../../reporters/models/json_reporter.dart';
import '../../../reporters/models/reporter.dart';
import 'reporters_list/console/unused_code_console_reporter.dart';
import 'reporters_list/json/unused_code_json_reporter.dart';

final _implementedReports = <String,
    Reporter<UnusedCodeFileReport, void, void> Function(IOSink output)>{
  ConsoleReporter.id: (output) => UnusedCodeConsoleReporter(output),
  JsonReporter.id: (output) => UnusedCodeJsonReporter(output),
};

Reporter<UnusedCodeFileReport, void, void>? reporter({
  required String name,
  required IOSink output,
}) {
  final constructor = _implementedReports[name];

  return constructor != null ? constructor(output) : null;
}
