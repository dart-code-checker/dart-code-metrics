import 'dart:io';

import '../../../reporters/models/checkstyle_reporter.dart';
import '../../../reporters/models/code_climate_reporter.dart';
import '../../../reporters/models/console_reporter.dart';
import '../../../reporters/models/file_report.dart';
import '../../../reporters/models/github_reporter.dart';
import '../../../reporters/models/html_reporter.dart';
import '../../../reporters/models/json_reporter.dart';
import '../../../reporters/models/reporter.dart';
import 'lint_report_params.dart';
import 'reporters_list/checkstyle/lint_checkstyle_reporter.dart';
import 'reporters_list/code_climate/lint_code_climate_reporter.dart';
import 'reporters_list/console/lint_console_reporter.dart';
import 'reporters_list/github/lint_github_reporter.dart';
import 'reporters_list/html/lint_html_reporter.dart';
import 'reporters_list/json/lint_json_reporter.dart';

final _implementedReports = <String,
    Reporter<FileReport, LintReportParams> Function(
  IOSink output,
  String reportFolder,
)>{
  CheckstyleReporter.id: (output, _) => LintCheckstyleReporter(output),
  ConsoleReporter.id: (output, _) => LintConsoleReporter(output),
  ConsoleReporter.verboseId: (output, _) =>
      LintConsoleReporter(output, reportAll: true),
  CodeClimateReporter.id: (output, _) => LintCodeClimateReporter(output),
  HtmlReporter.id: (_, reportFolder) => LintHtmlReporter(reportFolder),
  JsonReporter.id: (output, _) => LintJsonReporter(output),
  GitHubReporter.id: (output, _) => LintGitHubReporter(output),
  CodeClimateReporter.alternativeId: (output, _) =>
      LintCodeClimateReporter(output, gitlabCompatible: true),
};

Reporter<FileReport, LintReportParams>? reporter({
  required String name,
  required IOSink output,
  required String reportFolder,
}) {
  final constructor = _implementedReports[name];

  return constructor != null ? constructor(output, reportFolder) : null;
}
