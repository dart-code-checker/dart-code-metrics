import 'dart:io';

import 'package:dart_code_metrics/src/analyzers/unused_files_analyzer/reporters/reporter_factory.dart';
import 'package:dart_code_metrics/src/analyzers/unused_files_analyzer/reporters/reporters_list/console/unused_files_console_reporter.dart';
import 'package:dart_code_metrics/src/analyzers/unused_files_analyzer/reporters/reporters_list/json/unused_files_json_reporter.dart';
import 'package:test/test.dart';

void main() {
  test('Unused files reporter returns only required reporter', () {
    expect(
      reporter(name: '', output: stdout),
      isNull,
    );

    expect(
      reporter(
        name: 'console',
        output: stdout,
      ),
      isA<UnusedFilesConsoleReporter>(),
    );

    expect(
      reporter(
        name: 'json',
        output: stdout,
      ),
      isA<UnusedFilesJsonReporter>(),
    );
  });
}
