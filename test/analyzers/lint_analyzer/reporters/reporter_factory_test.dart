@TestOn('vm')
import 'dart:io';

import 'package:dart_code_metrics/src/analyzers/lint_analyzer/reporters/reporter_factory.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/reporters/reporters_list/code_climate/lint_code_climate_reporter.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/reporters/reporters_list/console/lint_console_reporter.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/reporters/reporters_list/github/lint_github_reporter.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/reporters/reporters_list/html/lint_html_reporter.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/reporters/reporters_list/json/lint_json_reporter.dart';
import 'package:dart_code_metrics/src/config_builder/models/config.dart';
import 'package:test/test.dart';

void main() {
  test('reporter returns only required reporter', () {
    const config = Config(
      excludePatterns: [],
      excludeForMetricsPatterns: [],
      metrics: {},
      rules: {},
      antiPatterns: {},
    );

    expect(
      reporter(name: '', output: stdout, config: config, reportFolder: ''),
      isNull,
    );
    expect(
      reporter(
        name: 'console',
        output: stdout,
        config: config,
        reportFolder: '',
      ),
      isA<LintConsoleReporter>(),
    );
    expect(
      reporter(
        name: 'console-verbose',
        output: stdout,
        config: config,
        reportFolder: '',
      ),
      isA<LintConsoleReporter>(),
    );
    expect(
      reporter(
        name: 'codeclimate',
        output: stdout,
        config: config,
        reportFolder: '',
      ),
      isA<LintCodeClimateReporter>(),
    );
    expect(
      reporter(
        name: 'html',
        output: stdout,
        config: config,
        reportFolder: '',
      ),
      isA<LintHtmlReporter>(),
    );
    expect(
      reporter(
        name: 'json',
        output: stdout,
        config: config,
        reportFolder: '',
      ),
      isA<LintJsonReporter>(),
    );
    expect(
      reporter(
        name: 'github',
        output: stdout,
        config: config,
        reportFolder: '',
      ),
      isA<LintGitHubReporter>(),
    );
    expect(
      reporter(
        name: 'gitlab',
        output: stdout,
        config: config,
        reportFolder: '',
      ),
      isA<LintCodeClimateReporter>(),
    );
  });
}
