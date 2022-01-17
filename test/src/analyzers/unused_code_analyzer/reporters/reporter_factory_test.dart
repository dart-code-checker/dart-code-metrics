import 'dart:io';

import 'package:dart_code_metrics/src/analyzers/unused_code_analyzer/reporters/reporter_factory.dart';
import 'package:dart_code_metrics/src/analyzers/unused_code_analyzer/reporters/reporters_list/console/unused_code_console_reporter.dart';
import 'package:dart_code_metrics/src/analyzers/unused_code_analyzer/reporters/reporters_list/json/unused_code_json_reporter.dart';
import 'package:test/test.dart';

void main() {
  test('Unused code reporter returns only required reporter', () {
    expect(
      reporter(name: '', output: stdout),
      isNull,
    );

    expect(
      reporter(
        name: 'console',
        output: stdout,
      ),
      isA<UnusedCodeConsoleReporter>(),
    );

    expect(
      reporter(
        name: 'json',
        output: stdout,
      ),
      isA<UnusedCodeJsonReporter>(),
    );
  });
}
