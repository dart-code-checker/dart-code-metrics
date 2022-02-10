import 'dart:convert';
import 'dart:io';

import 'package:dart_code_metrics/src/analyzers/unused_files_analyzer/models/unused_files_file_report.dart';
import 'package:dart_code_metrics/src/analyzers/unused_files_analyzer/reporters/reporters_list/json/unused_files_json_reporter.dart';
import 'package:dart_code_metrics/src/analyzers/unused_files_analyzer/reporters/unused_files_report_params.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class IOSinkMock extends Mock implements IOSink {}

void main() {
  group('UnusedFilesJsonReporter reports', () {
    const fullPath = '/home/developer/work/project/example.dart';

    // ignore: close_sinks
    late IOSinkMock output;
    late UnusedFilesJsonReporter reporter;

    setUp(() {
      output = IOSinkMock();

      reporter = UnusedFilesJsonReporter(output);
    });

    test('no unused files', () async {
      await reporter.report([]);

      verifyNever(() => output.write(captureAny()));
    });

    group('unused files', () {
      const record =
          UnusedFilesFileReport(path: fullPath, relativePath: 'example.dart');

      test('', () async {
        await reporter.report([record]);

        final captured = verify(
          () => output.write(captureAny()),
        ).captured.first as String;
        final report = json.decode(captured) as Map;

        expect(report, contains('unusedFiles'));
        expect(
          report['unusedFiles'],
          equals([
            {'path': 'example.dart'},
          ]),
        );
        expect(report, contains('automaticallyDeleted'));
        expect(report['automaticallyDeleted'], isFalse);
      });

      test('and about delete them', () async {
        await reporter.report(
          [record],
          additionalParams: const UnusedFilesReportParams(
            congratulate: false,
            deleteUnusedFiles: true,
          ),
        );

        final captured = verify(
          () => output.write(captureAny()),
        ).captured.first as String;
        final report = json.decode(captured) as Map;

        expect(report, contains('unusedFiles'));
        expect(
          report['unusedFiles'],
          equals([
            {'path': 'example.dart'},
          ]),
        );
        expect(report, contains('automaticallyDeleted'));
        expect(report['automaticallyDeleted'], isTrue);
      });
    });
  });
}
