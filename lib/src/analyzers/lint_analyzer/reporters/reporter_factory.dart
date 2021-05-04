import 'dart:io';

import '../../../cli/arguments_parser.dart';
import '../../../config_builder/models/config.dart';
import 'models/reporter.dart';
import 'reporters_list/code_climate/code_climate_reporter.dart';
import 'reporters_list/console_reporter.dart';
import 'reporters_list/github/github_reporter.dart';
import 'reporters_list/html/html_reporter.dart';
import 'reporters_list/json_reporter.dart';

final _implementedReports = <String,
    Reporter Function(IOSink output, Config config, String reportFolder)>{
  // ignore: deprecated_member_use_from_same_package
  consoleReporter: (output, _, __) => ConsoleReporter(output),
  consoleVerboseReporter: (output, _, __) =>
      // ignore: deprecated_member_use_from_same_package
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
