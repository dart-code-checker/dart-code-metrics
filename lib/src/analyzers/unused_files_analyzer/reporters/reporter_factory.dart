import 'dart:io';

import '../../../config_builder/models/config.dart';
import '../../../reporters/models/console_reporter.dart';
import '../../../reporters/models/json_reporter.dart';
import '../../../reporters/models/reporter.dart';
import 'reporters_list/console/lint_console_reporter.dart';
import 'reporters_list/json/unused_files_json_reporter.dart';

final _implementedReports = <String,
    Reporter Function(IOSink output, Config config, String reportFolder)>{
  ConsoleReporter.id: (output, _, __) => UnusedFilesConsoleReporter(output),
  ConsoleReporter.verboseId: (output, _, __) =>
      UnusedFilesConsoleReporter(output),
  JsonReporter.id: (output, _, __) => UnusedFilesJsonReporter(output),
};

Reporter? reporter({
  required String name,
  required IOSink output,
  required Config config,
  required String reportFolder,
}) {
  final constructor = _implementedReports[name];

  return constructor != null ? constructor(output, config, reportFolder) : null;
}
