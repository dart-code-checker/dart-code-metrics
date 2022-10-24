import 'dart:io';

import 'package:dart_code_metrics/src/analyzers/lint_analyzer/reporters/lint_report_params.dart';
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
      LintCheckstyleReporter(output).report(
        testReport,
        additionalParams:
            const LintReportParams(congratulate: true, summary: testSummary),
      );

      final captured = verify(
        () => output.writeln(captureAny()),
      ).captured.first as String;
      final report = XmlDocument.parse(captured);

      final file = report.findAllElements('file');
      expect(
        file.first.getAttribute('name'),
        equals('test/resources/abstract_class.dart'),
      );
      expect(
        file.last.getAttribute('name'),
        equals('test/resources/class_with_factory_constructors.dart'),
      );

      var errors = file.first.findAllElements('error').toList();
      expect(errors.first.getAttribute('line'), equals('0'));
      expect(errors.first.getAttribute('severity'), equals('warning'));
      expect(errors.first.getAttribute('message'), equals('metric comment'));
      expect(errors.first.getAttribute('source'), equals('file-metric-id'));
      expect(errors.last.getAttribute('line'), equals('0'));
      expect(errors.last.getAttribute('severity'), equals('error'));
      expect(errors.last.getAttribute('message'), equals('metric comment'));
      expect(errors.last.getAttribute('source'), equals('id'));

      errors = file.last.findAllElements('error').toList();
      expect(errors.first.getAttribute('line'), equals('0'));
      expect(errors.first.getAttribute('severity'), equals('warning'));
      expect(errors.first.getAttribute('message'), equals('simple message'));
      expect(errors.first.getAttribute('source'), equals('id'));

      expect(errors[1].getAttribute('line'), equals('0'));
      expect(errors[1].getAttribute('severity'), equals('info'));
      expect(
        errors[1].getAttribute('message'),
        equals('simple design message'),
      );
      expect(errors[1].getAttribute('source'), equals('designId'));

      expect(errors.last.getAttribute('line'), equals('0'));
      expect(errors.last.getAttribute('severity'), equals('warning'));
      expect(errors.last.getAttribute('message'), equals('metric comment'));
      expect(errors.last.getAttribute('source'), equals('id'));
    });
  });
}
