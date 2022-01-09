import 'dart:convert';
import 'dart:io';

import 'package:dart_code_metrics/src/analyzers/unused_l10n_analyzer/models/unused_l10n_file_report.dart';
import 'package:dart_code_metrics/src/analyzers/unused_l10n_analyzer/models/unused_l10n_issue.dart';
import 'package:dart_code_metrics/src/analyzers/unused_l10n_analyzer/reporters/reporters_list/json/unused_l10n_json_reporter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:source_span/source_span.dart';
import 'package:test/test.dart';

class IOSinkMock extends Mock implements IOSink {}

void main() {
  group('UnusedL10nJsonReporter reports', () {
    const fullPath = '/home/developer/work/project/example.dart';

    // ignore: close_sinks
    late IOSinkMock _output;
    late UnusedL10nJsonReporter _reporter;

    setUp(() {
      _output = IOSinkMock();

      _reporter = UnusedL10nJsonReporter(_output);
    });

    test('no unused files', () async {
      await _reporter.report([]);

      verifyNever(() => _output.write(captureAny()));
    });

    test('unused files', () async {
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
        () => _output.write(captureAny()),
      ).captured.first as String;
      final report = json.decode(captured) as Map;

      expect(report, contains('unusedLocalizations'));
      expect(
        report['unusedLocalizations'],
        equals([
          {
            'path': 'example.dart',
            'className': 'SomeClass',
            'issues': [
              {
                'memberName': 'someMethod()',
                'column': 3,
                'line': 5,
                'offset': 10,
              },
            ],
          },
        ]),
      );
    });
  });
}
