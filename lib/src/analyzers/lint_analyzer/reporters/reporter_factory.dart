import 'dart:io';

import '../../../config_builder/models/config.dart';
import '../../../reporters/models/code_climate_reporter.dart';
import '../../../reporters/models/console_reporter.dart';
import '../../../reporters/models/github_reporter.dart';
import '../../../reporters/models/html_reporter.dart';
import '../../../reporters/models/json_reporter.dart';
import '../../../reporters/models/reporter.dart';
import 'reporters_list/code_climate/lint_code_climate_reporter.dart';
import 'reporters_list/console/lint_console_reporter.dart';
import 'reporters_list/github/lint_github_reporter.dart';
import 'reporters_list/html/lint_html_reporter.dart';
import 'reporters_list/json/lint_json_reporter.dart';

final _implementedReports = <String,
    Reporter Function(IOSink output, Config config, String reportFolder)>{
  ConsoleReporter.id: (output, _, __) => LintConsoleReporter(output),
  ConsoleReporter.verboseId: (output, _, __) =>
      LintConsoleReporter(output, reportAll: true),
  CodeClimateReporter.id: (output, config, _) =>
      LintCodeClimateReporter(output, metrics: config.metrics),
  HtmlReporter.id: (_, __, reportFolder) => LintHtmlReporter(reportFolder),
  JsonReporter.id: (output, _, __) => LintJsonReporter(output),
  GitHubReporter.id: (output, _, __) => LintGitHubReporter(output),
  CodeClimateReporter.alternativeId: (output, config, _) =>
      LintCodeClimateReporter(
        output,
        metrics: config.metrics,
        gitlabCompatible: true,
      ),
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
