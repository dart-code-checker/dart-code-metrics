import 'dart:io';

import '../../../reporters/models/console_reporter.dart';
import '../../../reporters/models/json_reporter.dart';
import '../../../reporters/models/reporter.dart';
import 'reporters_list/console/unused_l10n_console_reporter.dart';
import 'reporters_list/json/unused_l10n_json_reporter.dart';

// ignore: avoid_private_typedef_functions
typedef _ReportersFactory = Reporter Function(IOSink output);

final _implementedReports = <String, _ReportersFactory>{
  ConsoleReporter.id: (output) => UnusedL10nConsoleReporter(output),
  JsonReporter.id: (output) => UnusedL10nJsonReporter(output),
};

Reporter? reporter({
  required String name,
  required IOSink output,
}) {
  final constructor = _implementedReports[name];

  return constructor != null ? constructor(output) : null;
}
