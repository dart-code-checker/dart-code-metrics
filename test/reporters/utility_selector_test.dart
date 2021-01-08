import 'package:code_checker/metrics.dart';
@TestOn('vm')
import 'package:dart_code_metrics/src/config/config.dart';
import 'package:dart_code_metrics/src/models/component_record.dart';
import 'package:dart_code_metrics/src/models/file_record.dart';
import 'package:dart_code_metrics/src/models/function_record.dart';
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
          components: Map.unmodifiable(<String, ComponentRecord>{
            'class': buildComponentRecordStub(methodsCount: 0),
            'mixin': buildComponentRecordStub(methodsCount: 15),
            'extension': buildComponentRecordStub(methodsCount: 25),
          }),
          functions: Map.unmodifiable(<String, FunctionRecord>{
            'function': buildFunctionRecordStub(argumentsCount: 0),
            'function2': buildFunctionRecordStub(argumentsCount: 6),
            'function3': buildFunctionRecordStub(argumentsCount: 10),
          }),
          issues: const [],
          designIssues: const [],
        ),
        const Config(),
      );
      expect(report.averageArgumentsCount, 5);
      expect(report.argumentsCountViolations, 2);
      expect(report.averageMethodsCount, 13);
      expect(report.methodsCountViolations, 2);
    });

    group('componentReport calculates report for function', () {
      test('without methods', () {
        final record = buildComponentRecordStub(methodsCount: 0);
        final report = UtilitySelector.componentReport(record, const Config());

        expect(report.methodsCount.value, 0);
        expect(report.methodsCount.level, MetricValueLevel.none);
      });

      test('with a lot of methods', () {
        const methodsCount = 30;

        final record = buildComponentRecordStub(methodsCount: methodsCount);
        final report = UtilitySelector.componentReport(record, const Config());

        expect(report.methodsCount.value, methodsCount);
        expect(report.methodsCount.level, MetricValueLevel.alarm);
      });
    });

    group('functionReport calculates report for function', () {
      test('without arguments', () {
        final record = buildFunctionRecordStub(argumentsCount: 0);
        final report = UtilitySelector.functionReport(record, const Config());

        expect(report.argumentsCount.value, 0);
        expect(report.argumentsCount.level, MetricValueLevel.none);
      });

      test('with a lot of arguments', () {
        final record = buildFunctionRecordStub(argumentsCount: 10);
        final report = UtilitySelector.functionReport(record, const Config());

        expect(report.argumentsCount.value, 10);
        expect(report.argumentsCount.level, MetricValueLevel.alarm);
      });

      test('without nesting information', () {
        final record = buildFunctionRecordStub(nestingLines: [[]]);
        final report = UtilitySelector.functionReport(record, const Config());

        expect(report.maximumNestingLevel.value, 0);
        expect(report.maximumNestingLevel.level, MetricValueLevel.none);
      });

      test('with high nesting level', () {
        final record = buildFunctionRecordStub(nestingLines: [
          [10],
          [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
          [1, 5, 10, 20],
        ]);
        final report = UtilitySelector.functionReport(record, const Config());

        expect(report.maximumNestingLevel.value, 12);
        expect(report.maximumNestingLevel.level, MetricValueLevel.alarm);
      });
    });

    test(
        'componentViolationLevel returns aggregated violation level for component',
        () {
      expect(
        UtilitySelector.componentViolationLevel(buildComponentReportStub(
          methodsCountViolationLevel: MetricValueLevel.warning,
        )),
        MetricValueLevel.warning,
      );
    });

    test(
        'functionViolationLevel returns aggregated violation level for function',
        () {
      expect(
        UtilitySelector.functionViolationLevel(buildFunctionReportStub(
          cyclomaticComplexityViolationLevel: MetricValueLevel.warning,
          linesOfExecutableCodeViolationLevel: MetricValueLevel.noted,
          maintainabilityIndexViolationLevel: MetricValueLevel.none,
        )),
        MetricValueLevel.warning,
      );

      expect(
        UtilitySelector.functionViolationLevel(buildFunctionReportStub(
          cyclomaticComplexityViolationLevel: MetricValueLevel.warning,
          linesOfExecutableCodeViolationLevel: MetricValueLevel.alarm,
          maintainabilityIndexViolationLevel: MetricValueLevel.none,
        )),
        MetricValueLevel.alarm,
      );

      expect(
        UtilitySelector.functionViolationLevel(buildFunctionReportStub(
          cyclomaticComplexityViolationLevel: MetricValueLevel.none,
          linesOfExecutableCodeViolationLevel: MetricValueLevel.none,
          maintainabilityIndexViolationLevel: MetricValueLevel.noted,
        )),
        MetricValueLevel.noted,
      );

      expect(
        UtilitySelector.functionViolationLevel(buildFunctionReportStub(
          cyclomaticComplexityViolationLevel: MetricValueLevel.none,
          linesOfExecutableCodeViolationLevel: MetricValueLevel.none,
          argumentsCountViolationLevel: MetricValueLevel.warning,
        )),
        MetricValueLevel.warning,
      );

      expect(
        UtilitySelector.functionViolationLevel(buildFunctionReportStub(
          cyclomaticComplexityViolationLevel: MetricValueLevel.none,
          linesOfExecutableCodeViolationLevel: MetricValueLevel.none,
          argumentsCountViolationLevel: MetricValueLevel.none,
          maximumNestingLevelViolationLevel: MetricValueLevel.warning,
        )),
        MetricValueLevel.warning,
      );
    });

    test('isIssueLevel', () {
      <MetricValueLevel, Matcher>{
        MetricValueLevel.none: isFalse,
        MetricValueLevel.noted: isFalse,
        MetricValueLevel.warning: isTrue,
        MetricValueLevel.alarm: isTrue,
      }.forEach((key, value) {
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
          components: Map.unmodifiable(<String, ComponentRecord>{}),
          functions: Map.unmodifiable(<String, FunctionRecord>{
            'a': buildFunctionRecordStub(linesWithCode: List.filled(10, 0)),
          }),
          issues: const [],
          designIssues: const [],
        ),
        FileRecord(
          fullPath: fullPathStub,
          relativePath: relativePathStub,
          components: Map.unmodifiable(<String, ComponentRecord>{}),
          functions: Map.unmodifiable(<String, FunctionRecord>{
            'a': buildFunctionRecordStub(linesWithCode: List.filled(20, 0)),
          }),
          issues: const [],
          designIssues: const [],
        ),
        FileRecord(
          fullPath: fullPathStub,
          relativePath: relativePathStub,
          components: Map.unmodifiable(<String, ComponentRecord>{}),
          functions: Map.unmodifiable(<String, FunctionRecord>{
            'a': buildFunctionRecordStub(linesWithCode: List.filled(30, 0)),
          }),
          issues: const [],
          designIssues: const [],
        ),
      ];

      test('MetricValueLevel.none if no violations', () {
        expect(
          UtilitySelector.maxViolationLevel(
            fileRecords,
            const Config(linesOfExecutableCodeWarningLevel: 100500),
          ),
          MetricValueLevel.none,
        );
      });

      test('MetricValueLevel.warning if maximum violation is warning', () {
        expect(
          UtilitySelector.maxViolationLevel(
            fileRecords,
            const Config(linesOfExecutableCodeWarningLevel: 20),
          ),
          MetricValueLevel.warning,
        );
      });

      test('MetricValueLevel.alarm if there are warning and alarm violations',
          () {
        expect(
          UtilitySelector.maxViolationLevel(
            fileRecords,
            const Config(linesOfExecutableCodeWarningLevel: 15),
          ),
          MetricValueLevel.warning,
        );
      });
    });
  });
}
