import 'dart:io';

import 'package:dart_code_metrics/src/analyzers/lint_analyzer/reporters/reporter_factory.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/reporters/reporters_list/code_climate/lint_code_climate_reporter.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/reporters/reporters_list/console/lint_console_reporter.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/reporters/reporters_list/github/lint_github_reporter.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/reporters/reporters_list/html/lint_html_reporter.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/reporters/reporters_list/json/lint_json_reporter.dart';
import 'package:test/test.dart';

void main() {
  test('reporter returns only required reporter', () {
    expect(
      reporter(name: '', output: stdout, reportFolder: ''),
      isNull,
    );
    expect(
      reporter(name: 'console', output: stdout, reportFolder: ''),
      isA<LintConsoleReporter>(),
    );
    expect(
      reporter(name: 'console-verbose', output: stdout, reportFolder: ''),
      isA<LintConsoleReporter>(),
    );
    expect(
      reporter(name: 'codeclimate', output: stdout, reportFolder: ''),
      isA<LintCodeClimateReporter>(),
    );
    expect(
      reporter(name: 'html', output: stdout, reportFolder: ''),
      isA<LintHtmlReporter>(),
    );
    expect(
      reporter(name: 'json', output: stdout, reportFolder: ''),
      isA<LintJsonReporter>(),
    );
    expect(
      reporter(name: 'github', output: stdout, reportFolder: ''),
      isA<LintGitHubReporter>(),
    );
    expect(
      reporter(name: 'gitlab', output: stdout, reportFolder: ''),
      isA<LintCodeClimateReporter>(),
    );
  });
}
