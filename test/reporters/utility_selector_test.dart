@TestOn('vm')
import 'package:dart_code_metrics/src/models/config.dart';
import 'package:dart_code_metrics/src/models/file_record.dart';
import 'package:dart_code_metrics/src/models/function_record.dart';
import 'package:dart_code_metrics/src/models/violation_level.dart';
import 'package:dart_code_metrics/src/reporters/utility_selector.dart';
import 'package:test/test.dart';

import '../stubs_builders.dart';

void main() {
  group('UtilitySelector', () {
    test('fileReport calculates report for file', () {
      final report = UtilitySelector.fileReport(
          FileRecord(
            fullPath: '/home/developer/work/project/example.dart',
            relativePath: 'example.dart',
            functions: Map.unmodifiable(<String, FunctionRecord>{
              'function': buildFunctionRecordStub(argumentsCount: 0),
              'function2': buildFunctionRecordStub(argumentsCount: 6),
              'function3': buildFunctionRecordStub(argumentsCount: 10),
            }),
            issues: const [],
          ),
          const Config());
      expect(report.averageArgumentsCount, 5);
      expect(report.totalArgumentsCountViolations, 2);
    });

    group('functionReport calculates report for function', () {
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
        'functionViolationLevel returns aggregated violation level for function',
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

    group('maxViolationLevel returns', () {
      const fullPathStub = '~/lib/src/foo.dart';
      const relativePathStub = 'lib/src/foo.dart';
      final fileRecords = [
        FileRecord(
          fullPath: fullPathStub,
          relativePath: relativePathStub,
          functions: Map.unmodifiable(<String, FunctionRecord>{
            'a': buildFunctionRecordStub(linesWithCode: List.filled(10, 0)),
          }),
          issues: const [],
        ),
        FileRecord(
          fullPath: fullPathStub,
          relativePath: relativePathStub,
          functions: Map.unmodifiable(<String, FunctionRecord>{
            'a': buildFunctionRecordStub(linesWithCode: List.filled(20, 0)),
          }),
          issues: const [],
        ),
        FileRecord(
          fullPath: fullPathStub,
          relativePath: relativePathStub,
          functions: Map.unmodifiable(<String, FunctionRecord>{
            'a': buildFunctionRecordStub(linesWithCode: List.filled(30, 0)),
          }),
          issues: const [],
        ),
      ];

      test('ViolationLevel.none if no violations', () {
        expect(
            UtilitySelector.maxViolationLevel(
                fileRecords, const Config(linesOfCodeWarningLevel: 100500)),
            ViolationLevel.none);
      });

      test('ViolationLevel.warning if maximum violation is warning', () {
        expect(
            UtilitySelector.maxViolationLevel(
                fileRecords, const Config(linesOfCodeWarningLevel: 20)),
            ViolationLevel.warning);
      });

      test('ViolationLevel.alarm if there are warning and alarm violations',
          () {
        expect(
            UtilitySelector.maxViolationLevel(
                fileRecords, const Config(linesOfCodeWarningLevel: 15)),
            ViolationLevel.warning);
      });
    });
  });
}
