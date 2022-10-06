import 'dart:io';

import 'package:ansicolor/ansicolor.dart';
import 'package:dart_code_metrics/src/analyzers/unused_files_analyzer/models/unused_files_file_report.dart';
import 'package:dart_code_metrics/src/analyzers/unused_files_analyzer/reporters/reporters_list/console/unused_files_console_reporter.dart';
import 'package:dart_code_metrics/src/analyzers/unused_files_analyzer/reporters/unused_files_report_params.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class IOSinkMock extends Mock implements IOSink {}

void main() {
  group('UnusedFilesConsoleReporter reports', () {
    const fullPath = '/home/developer/work/project/example.dart';

    late IOSinkMock output; // ignore: close_sinks

    late UnusedFilesConsoleReporter reporter;

    setUp(() {
      output = IOSinkMock();

      ansiColorDisabled = false;

      reporter = UnusedFilesConsoleReporter(output);
    });

    group('empty report', () {
      test('with congratulate param', () async {
        const congratulate = UnusedFilesReportParams(
          congratulate: true,
          deleteUnusedFiles: false,
        );

        await reporter.report([], additionalParams: congratulate);

        final captured =
            verify(() => output.writeln(captureAny())).captured.cast<String>();
        expect(
          captured,
          equals(['\x1B[38;5;70m✔\x1B[0m no unused files found!']),
        );
      });

      test('without congratulate param', () async {
        const noCongratulate = UnusedFilesReportParams(
          congratulate: false,
          deleteUnusedFiles: false,
        );

        await reporter.report([], additionalParams: noCongratulate);

        verifyNever(() => output.writeln(any()));
      });
    });

    group('unused files', () {
      test('without deleting flag', () async {
        const record =
            UnusedFilesFileReport(path: fullPath, relativePath: 'example.dart');

        await reporter.report([record]);

        final captured =
            verify(() => output.writeln(captureAny())).captured.cast<String>();

        expect(
          captured,
          equals([
            '\x1B[38;5;180m⚠\x1B[0m unused file: $fullPath',
            '',
            '\x1B[38;5;167m✖\x1B[0m total unused files - \x1B[38;5;167m1\x1B[0m',
          ]),
        );
      });

      test('with deleting flag', () async {
        const record =
            UnusedFilesFileReport(path: fullPath, relativePath: 'example.dart');

        await reporter.report(
          [record],
          additionalParams: const UnusedFilesReportParams(
            congratulate: true,
            deleteUnusedFiles: true,
          ),
        );

        final captured =
            verify(() => output.writeln(captureAny())).captured.cast<String>();

        expect(
          captured,
          equals([
            '\x1B[38;5;180m⚠\x1B[0m unused file: $fullPath',
            '',
            '\x1B[38;5;70m✔\x1B[0m \x1B[38;5;167m1\x1B[0m files were successfully deleted',
          ]),
        );
      });
    });
  });
}
