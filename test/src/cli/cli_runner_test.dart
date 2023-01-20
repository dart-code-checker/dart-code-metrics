import 'dart:io';

import 'package:dart_code_metrics/src/cli/cli_runner.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pub_updater/pub_updater.dart';
import 'package:test/test.dart';

class IOSinkMock extends Mock implements IOSink {}

class PubUpdaterMock extends Mock implements PubUpdater {}

void main() {
  group('Cli runner', () {
    test('should have correct description', () {
      expect(
        CliRunner().description,
        equals('Analyze and improve your code quality.'),
      );
    });

    test('should have correct invocation', () {
      expect(
        CliRunner().invocation,
        equals('metrics <command> [arguments] <directories>'),
      );
    });

    group('run', () {
      late IOSinkMock output; // ignore: close_sinks

      setUp(() {
        output = IOSinkMock();
      });

      test('with version argument', () {
        CliRunner(output, PubUpdaterMock()).run(['--version']);

        final captured =
            verify(() => output.writeln(captureAny())).captured.cast<String>();

        expect(captured, isNotEmpty);
        expect(captured.first, startsWith('DCM version: '));
      });
    });
  });
}
