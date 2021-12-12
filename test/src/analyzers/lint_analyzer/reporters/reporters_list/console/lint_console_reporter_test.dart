import 'dart:io';

import 'package:ansicolor/ansicolor.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/reporters/reporters_list/console/lint_console_reporter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../report_example.dart';

class IOSinkMock extends Mock implements IOSink {}

void main() {
  group('LintConsoleReporter reports in plain text format', () {
    late IOSinkMock output; // ignore: close_sinks
    late IOSinkMock verboseOutput; // ignore: close_sinks

    late LintConsoleReporter _reporter;
    late LintConsoleReporter _verboseReporter;

    setUp(() {
      output = IOSinkMock();
      verboseOutput = IOSinkMock();

      ansiColorDisabled = false;

      _reporter = LintConsoleReporter(output);
      _verboseReporter = LintConsoleReporter(verboseOutput, reportAll: true);
    });

    test('empty report', () async {
      await _reporter.report([]);
      await _verboseReporter.report([]);

      verifyNever(() => output.writeln(any()));
      verifyNever(() => verboseOutput.writeln(any()));
    });

    test('complex report', () async {
      await _reporter.report(testReport);
      await _verboseReporter.report(testReport);

      final captured = verify(
        () => output.writeln(captureAny()),
      ).captured.cast<String>();
      final capturedVerbose = verify(
        () => verboseOutput.writeln(captureAny()),
      ).captured.cast<String>();

      expect(
        captured,
        equals(
          [
            'test/resources/abstract_class.dart:',
            '\x1B[38;5;11mWarning \x1B[0mmetric1: \x1B[38;5;11m100 units\x1B[0m',
            '\x1B[38;5;9mAlarm   \x1B[0mclass.constructor - metric2: \x1B[38;5;9m10\x1B[0m',
            '',
            'test/resources/class_with_factory_constructors.dart:',
            '\x1B[38;5;11mWarning \x1B[0msimple message : 0:0 : id',
            '\x1B[38;5;4mStyle   \x1B[0msimple design message : 0:0 : designId',
            '\x1B[38;5;11mWarning \x1B[0mfunction - metric4: \x1B[38;5;11m5 units\x1B[0m',
            '',
          ],
        ),
      );
      expect(
        capturedVerbose,
        equals(
          [
            'test/resources/abstract_class.dart:',
            '\x1B[38;5;11mWarning \x1B[0mmetric1: \x1B[38;5;11m100 units\x1B[0m',
            '\x1B[38;5;7m        \x1B[0mclass - metric1: \x1B[38;5;7m0\x1B[0m',
            '\x1B[38;5;9mAlarm   \x1B[0mclass.constructor - metric2: \x1B[38;5;9m10\x1B[0m',
            '\x1B[38;5;7m        \x1B[0mclass.method - metric3: \x1B[38;5;7m1\x1B[0m',
            '',
            'test/resources/class_with_factory_constructors.dart:',
            '\x1B[38;5;7m        \x1B[0mmetric1: \x1B[38;5;7m0\x1B[0m, metric2: \x1B[38;5;7m1\x1B[0m',
            '\x1B[38;5;11mWarning \x1B[0msimple message : 0:0 : id',
            '\x1B[38;5;4mStyle   \x1B[0msimple design message : 0:0 : designId',
            '\x1B[38;5;11mWarning \x1B[0mfunction - metric4: \x1B[38;5;11m5 units\x1B[0m',
            '',
          ],
        ),
      );
    });
  });
}
