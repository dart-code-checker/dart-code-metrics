@TestOn('vm')
import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:dart_code_metrics/src/models/component_record.dart';
import 'package:dart_code_metrics/src/models/config.dart';
import 'package:dart_code_metrics/src/models/function_record.dart';
import 'package:dart_code_metrics/src/reporters/code_climate/code_climate_reporter.dart';
import 'package:test/test.dart';

import '../stubs_builders.dart';

void main() {
  group('CodeClimateReporter.report report about function', () {
    CodeClimateReporter _reporter;

    setUp(() {
      _reporter = CodeClimateReporter(reportConfig: Config());
    });

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
          json.decode(_reporter.report(records).first) as List<Object>;

      expect(report, isEmpty);
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

      expect(report, containsPair('type', 'issue'));
      expect(report, containsPair('check_name', 'numberOfArguments'));
      expect(
          report,
          containsPair('description',
              'Function `function` has 10 number of arguments (exceeds 4 allowed). Consider refactoring.'));
      expect(report, containsPair('categories', ['Complexity']));
      expect(
          report,
          containsPair('location', {
            'path': 'example.dart',
            'lines': {'begin': 0, 'end': 0}
          }));
      expect(report, containsPair('remediation_points', 50000));
      expect(report,
          containsPair('fingerprint', '9306995977c1febd3b6199617fbe68af'));
    });
  });
}
