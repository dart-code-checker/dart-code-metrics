@TestOn('vm')
import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:dart_code_metrics/src/models/component_record.dart';
import 'package:dart_code_metrics/src/models/config.dart';
import 'package:dart_code_metrics/src/models/function_record.dart';
import 'package:dart_code_metrics/src/reporters/json_reporter.dart';
import 'package:test/test.dart';

import '../stubs_builders.dart';

void main() {
  group('JsonReporter.report report about', () {
    JsonReporter _reporter;

    setUp(() {
      _reporter = JsonReporter(reportConfig: Config());
    });

    test('component', () {
      final records = [
        ComponentRecord(
            fullPath: '/home/developer/work/project/example.dart',
            relativePath: 'example.dart',
            records: BuiltMap.from(<String, FunctionRecord>{
              'function': buildFunctionRecordStub(argumentsCount: 0),
              'function2': buildFunctionRecordStub(argumentsCount: 6),
              'function3': buildFunctionRecordStub(argumentsCount: 10),
            }))
      ];

      final report =
          (json.decode(_reporter.report(records).first) as List<Object>).first
              as Map<String, Object>;

      expect(report, containsPair('average-number-of-arguments', 5));
      expect(report, containsPair('total-number-of-arguments-violations', 2));
    });

    group('function', () {
      test('without arguments', () {
        final records = [
          ComponentRecord(
              fullPath: '/home/developer/work/project/example.dart',
              relativePath: 'example.dart',
              records: BuiltMap.from(<String, FunctionRecord>{
                'function': buildFunctionRecordStub(argumentsCount: 0)
              }))
        ];

        final report =
            (json.decode(_reporter.report(records).first) as List<Object>).first
                as Map<String, Object>;
        final functionReport = (report['records']
            as Map<String, Object>)['function'] as Map<String, Object>;

        expect(functionReport, containsPair('number-of-arguments', 0));
        expect(functionReport,
            containsPair('number-of-arguments-violation-level', 'none'));
      });
      test('with a lot of arguments', () {
        final records = [
          ComponentRecord(
              fullPath: '/home/developer/work/project/example.dart',
              relativePath: 'example.dart',
              records: BuiltMap.from(<String, FunctionRecord>{
                'function': buildFunctionRecordStub(argumentsCount: 10)
              }))
        ];

        final report =
            (json.decode(_reporter.report(records).first) as List<Object>).first
                as Map<String, Object>;
        final functionReport = (report['records']
            as Map<String, Object>)['function'] as Map<String, Object>;

        expect(functionReport, containsPair('number-of-arguments', 10));
        expect(functionReport,
            containsPair('number-of-arguments-violation-level', 'alarm'));
      });
    });
  });
}
