import 'dart:convert';
import 'dart:io';

import 'package:dart_code_metrics/src/analyzers/unused_code_analyzer/models/unused_code_file_report.dart';
import 'package:dart_code_metrics/src/analyzers/unused_code_analyzer/models/unused_code_issue.dart';
import 'package:dart_code_metrics/src/analyzers/unused_code_analyzer/reporters/reporters_list/json/unused_code_json_reporter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:source_span/source_span.dart';
import 'package:test/test.dart';

class IOSinkMock extends Mock implements IOSink {}

void main() {
  group('UnusedCodeJsonReporter reports', () {
    const fullPath = '/home/developer/work/project/example.dart';

    // ignore: close_sinks
    late IOSinkMock output;
    late UnusedCodeJsonReporter reporter;

    setUp(() {
      output = IOSinkMock();

      reporter = UnusedCodeJsonReporter(output);
    });

    test('no unused files', () async {
      await reporter.report([]);

      verifyNever(() => output.write(captureAny()));
    });

    test('unused files', () async {
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

      await reporter.report(testReport);

      final captured = verify(
        () => output.write(captureAny()),
      ).captured.first as String;
      final report = json.decode(captured) as Map;

      expect(report, contains('unusedCode'));
      expect(
        report['unusedCode'],
        equals([
          {
            'path': 'example.dart',
            'issues': [
              {
                'declarationName': 'SomeClass',
                'declarationType': 'class',
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
