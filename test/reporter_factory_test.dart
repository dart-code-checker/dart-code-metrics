@TestOn('vm')
import 'dart:io';

import 'package:dart_code_metrics/src/config/config.dart';
import 'package:dart_code_metrics/src/obsoleted/reporters/code_climate/code_climate_reporter.dart';
import 'package:dart_code_metrics/src/obsoleted/reporters/console_reporter.dart';
import 'package:dart_code_metrics/src/obsoleted/reporters/github/github_reporter.dart';
import 'package:dart_code_metrics/src/obsoleted/reporters/html/html_reporter.dart';
import 'package:dart_code_metrics/src/reporter_factory.dart';
import 'package:dart_code_metrics/src/reporters/json_reporter.dart';
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
      isA<ConsoleReporter>(),
    );
    expect(
      reporter(
        name: 'console-verbose',
        output: stdout,
        config: config,
        reportFolder: '',
      ),
      isA<ConsoleReporter>(),
    );
    expect(
      reporter(
        name: 'codeclimate',
        output: stdout,
        config: config,
        reportFolder: '',
      ),
      isA<CodeClimateReporter>(),
    );
    expect(
      reporter(
        name: 'html',
        output: stdout,
        config: config,
        reportFolder: '',
      ),
      isA<HtmlReporter>(),
    );
    expect(
      reporter(
        name: 'json',
        output: stdout,
        config: config,
        reportFolder: '',
      ),
      isA<JsonReporter>(),
    );
    expect(
      reporter(
        name: 'github',
        output: stdout,
        config: config,
        reportFolder: '',
      ),
      isA<GitHubReporter>(),
    );
    expect(
      reporter(
        name: 'gitlab',
        output: stdout,
        config: config,
        reportFolder: '',
      ),
      isA<CodeClimateReporter>(),
    );
  });
}
