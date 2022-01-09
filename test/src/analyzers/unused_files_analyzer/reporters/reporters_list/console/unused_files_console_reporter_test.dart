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

      final report =
          verify(() => _output.writeln(captureAny())).captured.cast<String>();

      expect(report, equals(['\x1B[38;5;20m✔\x1B[0m no unused files found!']));
    });

    test('unused files', () async {
      const record =
          UnusedFilesFileReport(path: fullPath, relativePath: 'example.dart');

      await _reporter.report([record]);

      final report =
          verify(() => _output.writeln(captureAny())).captured.cast<String>();

      expect(
        report,
        equals([
          '\x1B[38;5;180m⚠\x1B[0m unused file: example.dart',
          '',
          '\x1B[38;5;167m✖\x1B[0m total unused files - \x1B[38;5;167m1\x1B[0m',
        ]),
      );
    });
  });
}
