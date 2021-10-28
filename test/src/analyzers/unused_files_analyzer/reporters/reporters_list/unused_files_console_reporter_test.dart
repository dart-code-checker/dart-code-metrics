@TestOn('vm')
import 'dart:io';

import 'package:ansicolor/ansicolor.dart';
import 'package:dart_code_metrics/src/analyzers/unused_files_analyzer/models/unused_files_file_report.dart';
import 'package:dart_code_metrics/src/analyzers/unused_files_analyzer/reporters/reporters_list/console/unused_files_console_reporter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class IOSinkMock extends Mock implements IOSink {}

void main() {
  group('UnusedFilesConsoleReporter reports', () {
    const fullPath = '/home/developer/work/project/example.dart';

    late IOSinkMock _output; // ignore: close_sinks
    late UnusedFilesConsoleReporter _reporter;

    setUp(() {
      _output = IOSinkMock();

      ansiColorDisabled = false;
      _reporter = UnusedFilesConsoleReporter(_output);
    });

    test('no unused files', () async {
      await _reporter.report([]);

      verify(() => _output.writeln('No unused files found!'));
    });

    test('unused files', () async {
      const record =
          UnusedFilesFileReport(path: fullPath, relativePath: 'example.dart');

      await _reporter.report([record]);

      final report =
          verify(() => _output.writeln(captureAny())).captured.cast<String>();

      expect(
        report[0],
        contains('Unused file: example.dart'),
      );
    });
  });
}
