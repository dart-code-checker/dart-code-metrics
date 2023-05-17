import 'dart:io';

import '../../../reporters/models/console_reporter.dart';
import '../../../reporters/models/json_reporter.dart';
import '../../../reporters/models/reporter.dart';
import '../models/unused_l10n_file_report.dart';
import 'reporters_list/console/unused_l10n_console_reporter.dart';
import 'reporters_list/json/unused_l10n_json_reporter.dart';
import 'unused_l10n_report_params.dart';

final _implementedReports = <String,
    Reporter<UnusedL10nFileReport, UnusedL10NReportParams> Function(
  IOSink output,
)>{
  ConsoleReporter.id: UnusedL10nConsoleReporter.new,
  JsonReporter.id: UnusedL10nJsonReporter.new,
};

Reporter<UnusedL10nFileReport, UnusedL10NReportParams>? reporter({
  required String name,
  required IOSink output,
}) {
  final constructor = _implementedReports[name];

  return constructor != null ? constructor(output) : null;
}
