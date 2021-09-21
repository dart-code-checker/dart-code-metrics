import 'dart:io';

import '../../../reporters/models/console_reporter.dart';
import '../../../reporters/models/json_reporter.dart';
import '../../../reporters/models/reporter.dart';
import 'reporters_list/console/unused_localization_console_reporter.dart';
import 'reporters_list/json/unused_localization_json_reporter.dart';

final _implementedReports = <String, Reporter Function(IOSink output)>{
  ConsoleReporter.id: (output) => UnusedLocalizationConsoleReporter(output),
  JsonReporter.id: (output) => UnusedLocalizationJsonReporter(output),
};

Reporter? reporter({
  required String name,
  required IOSink output,
}) {
  final constructor = _implementedReports[name];

  return constructor != null ? constructor(output) : null;
}
