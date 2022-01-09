import 'dart:io';

import 'package:dart_code_metrics/src/analyzers/unused_l10n_analyzer/reporters/reporter_factory.dart';
import 'package:dart_code_metrics/src/analyzers/unused_l10n_analyzer/reporters/reporters_list/console/unused_l10n_console_reporter.dart';
import 'package:dart_code_metrics/src/analyzers/unused_l10n_analyzer/reporters/reporters_list/json/unused_l10n_json_reporter.dart';
import 'package:test/test.dart';

void main() {
  test('Unused l10n reporter returns only required reporter', () {
    expect(
      reporter(name: '', output: stdout),
      isNull,
    );

    expect(
      reporter(
        name: 'console',
        output: stdout,
      ),
      isA<UnusedL10nConsoleReporter>(),
    );

    expect(
      reporter(
        name: 'json',
        output: stdout,
      ),
      isA<UnusedL10nJsonReporter>(),
    );
  });
}
