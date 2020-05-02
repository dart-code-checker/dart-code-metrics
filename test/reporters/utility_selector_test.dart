@TestOn('vm')
import 'package:dart_code_metrics/src/models/component_record.dart';
import 'package:dart_code_metrics/src/models/config.dart';
import 'package:dart_code_metrics/src/models/function_record.dart';
import 'package:dart_code_metrics/src/models/violation_level.dart';
import 'package:dart_code_metrics/src/reporters/utility_selector.dart';
import 'package:test/test.dart';

import '../stubs_builders.dart';

void main() {
  group('UtilitySelector', () {
    test('componentReport calculate report for file', () {
      final report = UtilitySelector.componentReport(
          ComponentRecord(
              fullPath: '/home/developer/work/project/example.dart',
              relativePath: 'example.dart',
              records: Map.unmodifiable(<String, FunctionRecord>{
                'function': buildFunctionRecordStub(argumentsCount: 0),
                'function2': buildFunctionRecordStub(argumentsCount: 6),
                'function3': buildFunctionRecordStub(argumentsCount: 10),
              })),
          const Config());
      expect(report.averageArgumentsCount, 5);
      expect(report.totalArgumentsCountViolations, 2);
    });
    group('functionReport calculate report for function', () {
      test('without arguments', () {
        final record = buildFunctionRecordStub(argumentsCount: 0);
        final report = UtilitySelector.functionReport(record, const Config());

        expect(report.argumentsCount.value, 0);
        expect(report.argumentsCount.violationLevel, ViolationLevel.none);
      });
      test('with a lot of arguments', () {
        final record = buildFunctionRecordStub(argumentsCount: 10);
        final report = UtilitySelector.functionReport(record, const Config());
        expect(report.argumentsCount.value, 10);
        expect(report.argumentsCount.violationLevel, ViolationLevel.alarm);
      });
    });
    test(
        'functionViolationLevel return aggregated violation level for function',
        () {
      expect(
          UtilitySelector.functionViolationLevel(buildFunctionReportStub(
              cyclomaticComplexityViolationLevel: ViolationLevel.warning,
              linesOfCodeViolationLevel: ViolationLevel.noted,
              maintainabilityIndexViolationLevel: ViolationLevel.none)),
          ViolationLevel.warning);

      expect(
          UtilitySelector.functionViolationLevel(buildFunctionReportStub(
              cyclomaticComplexityViolationLevel: ViolationLevel.warning,
              linesOfCodeViolationLevel: ViolationLevel.alarm,
              maintainabilityIndexViolationLevel: ViolationLevel.none)),
          ViolationLevel.alarm);

      expect(
          UtilitySelector.functionViolationLevel(buildFunctionReportStub(
              cyclomaticComplexityViolationLevel: ViolationLevel.none,
              linesOfCodeViolationLevel: ViolationLevel.none,
              maintainabilityIndexViolationLevel: ViolationLevel.noted)),
          ViolationLevel.noted);

      expect(
          UtilitySelector.functionViolationLevel(buildFunctionReportStub(
              cyclomaticComplexityViolationLevel: ViolationLevel.none,
              linesOfCodeViolationLevel: ViolationLevel.none,
              argumentsCountViolationLevel: ViolationLevel.warning)),
          ViolationLevel.warning);
    });
    test('isIssueLevel', () {
      const violationsMapping = {
        ViolationLevel.none: isFalse,
        ViolationLevel.noted: isFalse,
        ViolationLevel.warning: isTrue,
        ViolationLevel.alarm: isTrue,
      };

      assert(violationsMapping.keys.length == ViolationLevel.values.length,
          'invalid sizes');

      violationsMapping.forEach((key, value) {
        expect(UtilitySelector.isIssueLevel(key), value);
      });
    });
  });
}
