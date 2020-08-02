@TestOn('vm')
import 'package:dart_code_metrics/src/models/code_issue.dart';
import 'package:dart_code_metrics/src/models/code_issue_severity.dart';
import 'package:dart_code_metrics/src/models/component_record.dart';
import 'package:dart_code_metrics/src/models/config.dart';
import 'package:dart_code_metrics/src/models/file_record.dart';
import 'package:dart_code_metrics/src/models/function_record.dart';
import 'package:dart_code_metrics/src/reporters/console_reporter.dart';
import 'package:source_span/source_span.dart';
import 'package:test/test.dart';

import '../stubs_builders.dart';

void main() {
  group('ConsoleReporter.report report about', () {
    ConsoleReporter _reporter;
    ConsoleReporter _verboseReporter;

    setUp(() {
      _reporter = ConsoleReporter(reportConfig: const Config());
      _verboseReporter =
          ConsoleReporter(reportConfig: const Config(), reportAll: true);
    });

    test('files without any records', () {
      final report = _reporter.report([]);
      final verboseReport = _verboseReporter.report([]).toList();

      expect(report, isEmpty);
      expect(verboseReport, isEmpty);
    });

    group('component', () {
      test('without methods', () {
        final records = [
          FileRecord(
            fullPath: '/home/developer/work/project/example.dart',
            relativePath: 'example.dart',
            components: Map.unmodifiable(<String, ComponentRecord>{
              'class': buildComponentRecordStub(methodsCount: 0),
            }),
            functions: Map.unmodifiable(<String, FunctionRecord>{}),
            issues: const [],
          ),
        ];

        final report = _reporter.report(records);
        final verboseReport = _verboseReporter.report(records).toList();

        expect(report, isEmpty);
        expect(verboseReport.length, 3);
        expect(verboseReport[1],
            contains('number of methods: \x1B[38;5;7m0\x1B[0m'));
      });

      test('with a lot of methods', () {
        final records = [
          FileRecord(
            fullPath: '/home/developer/work/project/example.dart',
            relativePath: 'example.dart',
            components: Map.unmodifiable(<String, ComponentRecord>{
              'class': buildComponentRecordStub(methodsCount: 20),
            }),
            functions: Map.unmodifiable(<String, FunctionRecord>{}),
            issues: const [],
          ),
        ];

        final report = _reporter.report(records).toList();

        expect(report.length, 3);
        expect(report[1], contains('number of methods: \x1B[38;5;3m20\x1B[0m'));
      });
    });

    group('function', () {
      test('without arguments', () {
        final records = [
          FileRecord(
            fullPath: '/home/developer/work/project/example.dart',
            relativePath: 'example.dart',
            components: Map.unmodifiable(<String, ComponentRecord>{}),
            functions: Map.unmodifiable(<String, FunctionRecord>{
              'function': buildFunctionRecordStub(argumentsCount: 0),
            }),
            issues: const [],
          ),
        ];

        final report = _reporter.report(records);
        final verboseReport = _verboseReporter.report(records).toList();

        expect(report, isEmpty);
        expect(verboseReport.length, 3);
        expect(verboseReport[1],
            contains('number of arguments: \x1B[38;5;7m0\x1B[0m'));
      });

      test('with a lot of arguments', () {
        final records = [
          FileRecord(
            fullPath: '/home/developer/work/project/example.dart',
            relativePath: 'example.dart',
            components: Map.unmodifiable(<String, ComponentRecord>{}),
            functions: Map.unmodifiable(<String, FunctionRecord>{
              'function': buildFunctionRecordStub(argumentsCount: 10),
            }),
            issues: const [],
          ),
        ];

        final report = _reporter.report(records).toList();

        expect(report.length, 3);
        expect(
            report[1], contains('number of arguments: \x1B[38;5;1m10\x1B[0m'));
      });
    });

    test('style severity issues', () {
      final records = [
        FileRecord(
          fullPath: '/home/developer/work/project/example.dart',
          relativePath: 'example.dart',
          components: Map.unmodifiable(<String, ComponentRecord>{}),
          functions: Map.unmodifiable(<String, FunctionRecord>{}),
          issues: [
            CodeIssue(
              ruleId: 'ruleId1',
              ruleDocumentation: Uri.parse('https://docu.edu/ruleId1.html'),
              severity: CodeIssueSeverity.style,
              sourceSpan: SourceSpanBase(
                  SourceLocation(1,
                      sourceUrl: Uri.parse(
                          '/home/developer/work/project/example.dart'),
                      line: 2,
                      column: 3),
                  SourceLocation(6,
                      sourceUrl: Uri.parse(
                          '/home/developer/work/project/example.dart')),
                  'issue'),
              message: 'first issue message',
              correction: 'correction',
              correctionComment: 'correction comment',
            ),
          ],
        ),
      ];

      final report = _reporter.report(records).toList();

      expect(report.length, 3);
      expect(
          report[1],
          equals(
              '\x1B[38;5;4mStyle   \x1B[0mfirst issue message : 2:3 : ruleId1 https://docu.edu/ruleId1.html'));
    });
  });
}
