import 'dart:convert';
import 'dart:io';

import 'package:dart_code_metrics/src/analyzers/lint_analyzer/reporters/lint_report_params.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/reporters/reporters_list/json/lint_json_reporter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../report_example.dart';

class IOSinkMock extends Mock implements IOSink {}

void main() {
  group('LintJsonReporter reports in json format', () {
    // ignore: close_sinks
    late IOSinkMock output;

    setUp(() {
      output = IOSinkMock();
    });

    test('empty report', () {
      LintJsonReporter(output).report([]);

      verifyNever(() => output.write(captureAny()));
    });

    test('complex report', () {
      LintJsonReporter(output).report(
        testReport,
        additionalParams:
            const LintReportParams(congratulate: true, summary: testSummary),
      );

      final captured = verify(
        () => output.write(captureAny()),
      ).captured.first as String;
      final report = json.decode(captured) as Map;

      expect(report, contains('records'));
      expect(report['records'] as Iterable, hasLength(2));

      final recordFirst = (report['records'] as Iterable).first as Map;
      expect(recordFirst, containsPair('path', src1Path));
      expect(
        recordFirst['fileMetrics'],
        equals([
          {
            'metricsId': 'file-metric-id',
            'value': 100,
            'unitType': 'units',
            'level': 'warning',
            'comment': 'metric comment',
            'context': <String>[],
          },
        ]),
      );

      final recordLast = (report['records'] as Iterable).last as Map;
      expect(recordLast, containsPair('path', src2Path));
      expect(
        recordLast['issues'],
        equals([
          {
            'ruleId': 'id',
            'documentation': 'https://documentation.com',
            'codeSpan': {
              'start': {'offset': 0, 'line': 0, 'column': 0},
              'end': {'offset': 20, 'line': 0, 'column': 20},
              'text': 'simple function body',
            },
            'severity': 'warning',
            'message': 'simple message',
            'verboseMessage': 'verbose message',
            'suggestion': {
              'comment': 'replacement comment',
              'replacement': 'function body',
            },
          },
        ]),
      );
      expect(
        recordLast['antiPatternCases'],
        equals([
          {
            'ruleId': 'designId',
            'documentation': 'https://documentation.com',
            'codeSpan': {
              'start': {'offset': 0, 'line': 0, 'column': 0},
              'end': {'offset': 20, 'line': 0, 'column': 20},
              'text': 'simple function body',
            },
            'severity': 'style',
            'message': 'simple design message',
            'verboseMessage': 'verbose design message',
          },
        ]),
      );

      expect(report, contains('summary'));
      expect(report['summary'] as Iterable, hasLength(3));

      expect(
        (report['summary'] as Iterable).first as Map,
        equals({
          'status': 'none',
          'title': 'Scanned package folders',
          'value': ['bin', 'example', 'lib', 'test'],
          'violations': 0,
        }),
      );

      expect(
        (report['summary'] as Iterable).last as Map,
        equals({
          'status': 'warning',
          'title': 'Average Source Lines of Code per method',
          'value': 30,
          'violations': 2,
        }),
      );
    });
  });
}
