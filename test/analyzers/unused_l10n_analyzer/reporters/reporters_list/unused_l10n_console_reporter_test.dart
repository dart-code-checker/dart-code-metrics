@TestOn('vm')
import 'dart:io';

import 'package:ansicolor/ansicolor.dart';
import 'package:dart_code_metrics/src/analyzers/unused_l10n_analyzer/models/unused_l10n_file_report.dart';
import 'package:dart_code_metrics/src/analyzers/unused_l10n_analyzer/models/unused_l10n_issue.dart';
import 'package:dart_code_metrics/src/analyzers/unused_l10n_analyzer/reporters/reporters_list/console/unused_l10n_console_reporter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:source_span/source_span.dart';
import 'package:test/test.dart';

class IOSinkMock extends Mock implements IOSink {}

void main() {
  group('UnusedL10nConsoleReporter reports in plain text format', () {
    const fullPath = '/home/developer/work/project/example.dart';

    late IOSinkMock output; // ignore: close_sinks

    late UnusedL10nConsoleReporter _reporter;

    setUp(() {
      output = IOSinkMock();

      ansiColorDisabled = false;

      _reporter = UnusedL10nConsoleReporter(output);
    });

    test('empty report', () async {
      await _reporter.report([]);

      final captured = verify(
        () => output.writeln(captureAny()),
      ).captured.cast<String>();

      expect(captured, ['✔ no unused localization found!']);
    });

    test('complex report', () async {
      final testReport = [
        UnusedL10nFileReport(
          path: fullPath,
          relativePath: 'example.dart',
          issues: [
            UnusedL10nIssue(
              memberName: 'someMethod()',
              location: SourceLocation(10, line: 5, column: 3),
            ),
          ],
          className: 'SomeClass',
        ),
      ];

      await _reporter.report(testReport);

      final captured = verify(
        () => output.writeln(captureAny()),
      ).captured.cast<String>();

      expect(
        captured,
        equals(
          [
            'class SomeClass',
            '⚠ unused someMethod()',
            'at example.dart:5:3',
            '',
            '✖ total unused localization usages - \x1B[38;5;3m1\x1B[0m',
          ],
        ),
      );
    });
  });
}
