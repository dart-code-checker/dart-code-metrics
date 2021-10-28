@TestOn('vm')
import 'dart:convert';
import 'dart:io';

import 'package:dart_code_metrics/src/analyzers/unused_files_analyzer/models/unused_files_file_report.dart';
import 'package:dart_code_metrics/src/analyzers/unused_files_analyzer/reporters/reporters_list/json/unused_files_json_reporter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class IOSinkMock extends Mock implements IOSink {}

void main() {
  group('UnusedFilesJsonReporter reports', () {
    const fullPath = '/home/developer/work/project/example.dart';

    // ignore: close_sinks
    late IOSinkMock _output;
    late UnusedFilesJsonReporter _reporter;

    setUp(() {
      _output = IOSinkMock();

      _reporter = UnusedFilesJsonReporter(_output);
    });

    test('no unused files', () async {
      await _reporter.report([]);

      verifyNever(() => _output.write(captureAny()));
    });

    test('unused files', () async {
      const record =
          UnusedFilesFileReport(path: fullPath, relativePath: 'example.dart');

      await _reporter.report([record]);

      final captured = verify(
        () => _output.write(captureAny()),
      ).captured.first as String;
      final report = json.decode(captured) as Map;

      expect(report, contains('unusedFiles'));
      expect(
        report['unusedFiles'],
        equals([
          {
            'path': 'example.dart',
          },
        ]),
      );
    });
  });
}
