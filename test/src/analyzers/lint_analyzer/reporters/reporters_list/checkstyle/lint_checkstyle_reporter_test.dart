import 'dart:io';

import 'package:dart_code_metrics/src/analyzers/lint_analyzer/reporters/reporters_list/checkstyle/lint_checkstyle_reporter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';

import '../report_example.dart';

class IOSinkMock extends Mock implements IOSink {}

void main() {
  group('LintCheckstyleReporter reports in json format', () {
    // ignore: close_sinks
    late IOSinkMock output;

    setUp(() {
      output = IOSinkMock();
    });

    test('empty report', () {
      LintCheckstyleReporter(output).report([]);

      verifyNever(() => output.write(captureAny()));
    });

    test('complex report', () {
      LintCheckstyleReporter(output).report(testReport, summary: testSummary);

      final captured = verify(
        () => output.writeln(captureAny()),
      ).captured.first as String;
      final report = XmlDocument.parse(captured);

      final file = report.findAllElements('file');
      expect(
        file.first.getAttribute('name'),
        equals('test/resources/class_with_factory_constructors.dart'),
      );

      final errors = report.findAllElements('error');
      expect(errors.first.getAttribute('line'), equals('0'));
      expect(errors.first.getAttribute('severity'), equals('warning'));
      expect(errors.first.getAttribute('message'), equals('simple message'));
      expect(errors.first.getAttribute('source'), equals('id'));

      expect(errors.last.getAttribute('line'), equals('0'));
      expect(errors.last.getAttribute('severity'), equals('info'));
      expect(
        errors.last.getAttribute('message'),
        equals('simple design message'),
      );
      expect(errors.last.getAttribute('source'), equals('designId'));
    });
  });
}
