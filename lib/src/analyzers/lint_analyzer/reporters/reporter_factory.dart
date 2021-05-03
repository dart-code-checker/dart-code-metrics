import 'dart:io';

import '../../../cli/arguments_parser.dart';
import '../../../config_builder/models/config.dart';
import '../../../reporters/models/reporter.dart';
import 'reporters_list/code_climate/lint_code_climate_reporter.dart';
import 'reporters_list/console/lint_console_reporter.dart';
import 'reporters_list/github/lint_github_reporter.dart';
import 'reporters_list/html/lint_html_reporter.dart';
import 'reporters_list/json/lint_json_reporter.dart';

final _implementedReports = <String,
    Reporter Function(IOSink output, Config config, String reportFolder)>{
  consoleReporter: (output, _, __) => LintConsoleReporter(output),
  consoleVerboseReporter: (output, _, __) =>
      LintConsoleReporter(output, reportAll: true),
  codeClimateReporter: (output, config, _) =>
      LintCodeClimateReporter(output, metrics: config.metrics),
  htmlReporter: (_, __, reportFolder) => LintHtmlReporter(reportFolder),
  jsonReporter: (output, _, __) => LintJsonReporter(output),
  githubReporter: (output, _, __) => LintGitHubReporter(output),
  gitlabCodeClimateReporter: (output, config, _) => LintCodeClimateReporter(
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
