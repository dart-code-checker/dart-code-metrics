import 'package:dart_code_metrics/metrics_analyzer.dart';
import 'package:dart_code_metrics/src/models/component_record.dart';
import 'package:dart_code_metrics/src/models/function_record.dart';
import 'package:dart_code_metrics/src/models/violation_level.dart';
import 'package:dart_code_metrics/src/reporters/utility_selector.dart';
import 'package:test/test.dart';
import 'stubs_builders.dart';

void main() {
  group('UtilitySelector', () {
    group('maxViolationLevel', () {
      const fullPathStub = '~/lib/src/foo.dart';
      const relativePathStub = 'lib/src/foo.dart';
      final componentRecords = [
        ComponentRecord(
          fullPath: fullPathStub,
          relativePath: relativePathStub,
          records: Map.unmodifiable(<String, FunctionRecord>{
            'a': buildFunctionRecordStub(linesWithCode: List.filled(10, 0))
          }),
          issues: const [],
        ),
        ComponentRecord(
          fullPath: fullPathStub,
          relativePath: relativePathStub,
          records: Map.unmodifiable(<String, FunctionRecord>{
            'a': buildFunctionRecordStub(linesWithCode: List.filled(20, 0))
          }),
          issues: const [],
        ),
        ComponentRecord(
          fullPath: fullPathStub,
          relativePath: relativePathStub,
          records: Map.unmodifiable(<String, FunctionRecord>{
            'a': buildFunctionRecordStub(linesWithCode: List.filled(30, 0))
          }),
          issues: const [],
        ),
      ];

      test('returns ViolationLevel.none if no violations', () {
        expect(
            UtilitySelector.maxViolationLevel(componentRecords,
                const Config(linesOfCodeWarningLevel: 100500)),
            ViolationLevel.none);
      });

      test('returns ViolationLevel.warning if maximum violation is warning',
          () {
        expect(
            UtilitySelector.maxViolationLevel(
                componentRecords, const Config(linesOfCodeWarningLevel: 20)),
            ViolationLevel.warning);
      });

      test(
          'returns ViolationLevel.alarm if there are warning and alarm violations',
          () {
        expect(
            UtilitySelector.maxViolationLevel(
                componentRecords, const Config(linesOfCodeWarningLevel: 15)),
            ViolationLevel.warning);
      });
    });
  });
}
