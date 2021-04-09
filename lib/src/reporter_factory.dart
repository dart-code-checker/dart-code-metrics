import 'dart:io';

import 'cli/arguments_parser.dart';
import 'config/config.dart';
import 'obsoleted/reporters/code_climate/code_climate_reporter.dart';
import 'obsoleted/reporters/console_reporter.dart';
import 'obsoleted/reporters/github/github_reporter.dart';
import 'obsoleted/reporters/html/html_reporter.dart';
import 'obsoleted/reporters/json_reporter.dart';
import 'reporters/reporter.dart';

final _implementedReports = <String,
    Reporter Function(IOSink output, Config config, String reportFolder)>{
  consoleReporter: (output, _, __) => ConsoleReporter(output),
  consoleVerboseReporter: (output, _, __) =>
      ConsoleReporter(output, reportAll: true),
  codeClimateReporter: (output, config, __) =>
      CodeClimateReporter(output, reportConfig: config),
  htmlReporter: (_, __, reportFolder) =>
      HtmlReporter(reportFolder: reportFolder),
  jsonReporter: (output, _, __) => JsonReporter(output),
  githubReporter: (output, _, __) => GitHubReporter(output),
  gitlabCodeClimateReporter: (output, config, __) => CodeClimateReporter(
        output,
        reportConfig: config,
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
