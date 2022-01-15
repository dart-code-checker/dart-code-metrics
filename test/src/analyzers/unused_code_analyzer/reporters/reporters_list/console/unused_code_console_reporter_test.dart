import 'dart:io';

import 'package:ansicolor/ansicolor.dart';
import 'package:dart_code_metrics/src/analyzers/unused_code_analyzer/models/unused_code_file_report.dart';
import 'package:dart_code_metrics/src/analyzers/unused_code_analyzer/models/unused_code_issue.dart';
import 'package:dart_code_metrics/src/analyzers/unused_code_analyzer/reporters/reporters_list/console/unused_code_console_reporter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:source_span/source_span.dart';
import 'package:test/test.dart';

class IOSinkMock extends Mock implements IOSink {}

void main() {
  group('UnusedCodeConsoleReporter reports in plain text format', () {
    const fullPath = '/home/developer/work/project/example.dart';

    late IOSinkMock output; // ignore: close_sinks

    late UnusedCodeConsoleReporter _reporter;

    setUp(() {
      output = IOSinkMock();

      ansiColorDisabled = false;

      _reporter = UnusedCodeConsoleReporter(output);
    });

    test('empty report', () async {
      await _reporter.report([]);

      final captured = verify(
        () => output.writeln(captureAny()),
      ).captured.cast<String>();

      expect(captured, ['\x1B[38;5;20m✔\x1B[0m no unused code found!']);
    });

    test('complex report', () async {
      final testReport = [
        UnusedCodeFileReport(
          path: fullPath,
          relativePath: 'example.dart',
          issues: [
            UnusedCodeIssue(
              declarationName: 'SomeClass',
              declarationType: 'class',
              location: SourceLocation(10, line: 5, column: 3),
            ),
          ],
        ),
      ];

      await _reporter.report(testReport);

      final captured =
          verify(() => output.writeln(captureAny())).captured.cast<String>();

      expect(
        captured,
        equals([
          'example.dart:',
          '    \x1B[38;5;180m⚠\x1B[0m unused class SomeClass',
          '      at example.dart:5:3',
          '',
          '\x1B[38;5;167m✖\x1B[0m total unused code (classes, functions, variables, extensions, enums, mixins and type aliases) - \x1B[38;5;167m1\x1B[0m',
        ]),
      );
    });
  });
}
