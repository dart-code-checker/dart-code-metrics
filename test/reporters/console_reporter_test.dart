@TestOn('vm')
import 'package:dart_code_metrics/src/models/component_record.dart';
import 'package:dart_code_metrics/src/models/config.dart';
import 'package:dart_code_metrics/src/models/function_record.dart';
import 'package:dart_code_metrics/src/reporters/console_reporter.dart';
import 'package:test/test.dart';

import '../stubs_builders.dart';

void main() {
  group('ConsoleReporter.report report about function', () {
    ConsoleReporter _reporter;
    ConsoleReporter _verboseReporter;

    setUp(() {
      _reporter = ConsoleReporter(reportConfig: const Config());
      _verboseReporter =
          ConsoleReporter(reportConfig: const Config(), reportAll: true);
    });
    test('without arguments', () {
      final records = [
        ComponentRecord(
          fullPath: '/home/developer/work/project/example.dart',
          relativePath: 'example.dart',
          records: Map.unmodifiable(<String, FunctionRecord>{
            'function': buildFunctionRecordStub(argumentsCount: 0)
          }),
          issues: const [],
        )
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
        ComponentRecord(
          fullPath: '/home/developer/work/project/example.dart',
          relativePath: 'example.dart',
          records: Map.unmodifiable(<String, FunctionRecord>{
            'function': buildFunctionRecordStub(argumentsCount: 10)
          }),
          issues: const [],
        )
      ];

      final report = _reporter.report(records).toList();

      expect(report.length, 3);
      expect(report[1], contains('number of arguments: \x1B[38;5;1m10\x1B[0m'));
    });
  });
}
