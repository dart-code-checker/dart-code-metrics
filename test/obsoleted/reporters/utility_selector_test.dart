@TestOn('vm')
import 'package:code_checker/checker.dart';
import 'package:code_checker/metrics.dart';
import 'package:dart_code_metrics/src/obsoleted/config/config.dart' as metrics;
import 'package:dart_code_metrics/src/obsoleted/models/file_record.dart';
import 'package:dart_code_metrics/src/obsoleted/models/function_record.dart';
import 'package:dart_code_metrics/src/obsoleted/reporters/utility_selector.dart';
import 'package:test/test.dart';

import '../stubs_builders.dart';

void main() {
  group('UtilitySelector', () {
    test('fileReport calculates report for file', () {
      final report = UtilitySelector.fileReport(
        FileRecord(
          fullPath: '/home/developer/work/project/example.dart',
          relativePath: 'example.dart',
          components: Map.unmodifiable(<String, Report>{
            'class': buildComponentRecordStub(metrics: const [
              MetricValue<int>(
                metricsId: NumberOfMethodsMetric.metricId,
                value: 0,
                level: MetricValueLevel.none,
                comment: '',
              ),
            ]),
            'mixin': buildComponentRecordStub(metrics: const [
              MetricValue<int>(
                metricsId: NumberOfMethodsMetric.metricId,
                value: 15,
                level: MetricValueLevel.warning,
                comment: '',
              ),
            ]),
            'extension': buildComponentRecordStub(metrics: const [
              MetricValue<int>(
                metricsId: NumberOfMethodsMetric.metricId,
                value: 25,
                level: MetricValueLevel.alarm,
                comment: '',
              ),
            ]),
          }),
          functions: Map.unmodifiable(<String, FunctionRecord>{
            'function': buildFunctionRecordStub(argumentsCount: 0),
            'function2': buildFunctionRecordStub(argumentsCount: 6),
            'function3': buildFunctionRecordStub(argumentsCount: 10),
          }),
          issues: const [],
          designIssues: const [],
        ),
        const metrics.Config(),
      );
      expect(report.averageArgumentsCount, 5);
      expect(report.argumentsCountViolations, 2);
      expect(report.averageMethodsCount, 13);
      expect(report.methodsCountViolations, 2);
    });

    group('componentReport calculates report for function', () {
      test('without methods', () {
        final record = buildComponentRecordStub(metrics: const [
          MetricValue<int>(
            metricsId: NumberOfMethodsMetric.metricId,
            value: 0,
            level: MetricValueLevel.none,
            comment: '',
          ),
        ]);
        final report =
            UtilitySelector.componentReport(record, const metrics.Config());

        expect(report.methodsCount.value, 0);
        expect(report.methodsCount.level, MetricValueLevel.none);
      });

      test('with a lot of methods', () {
        const methodsCount = 30;

        final record = buildComponentRecordStub(metrics: const [
          MetricValue<int>(
            metricsId: NumberOfMethodsMetric.metricId,
            value: methodsCount,
            level: MetricValueLevel.alarm,
            comment: '',
          ),
        ]);
        final report =
            UtilitySelector.componentReport(record, const metrics.Config());

        expect(report.methodsCount.value, methodsCount);
        expect(report.methodsCount.level, MetricValueLevel.alarm);
      });
    });

    group('functionReport calculates report for function', () {
      test('without arguments', () {
        final record = buildFunctionRecordStub(argumentsCount: 0);
        final report =
            UtilitySelector.functionReport(record, const metrics.Config());

        expect(report.argumentsCount.value, 0);
        expect(report.argumentsCount.level, MetricValueLevel.none);
      });

      test('with a lot of arguments', () {
        final record = buildFunctionRecordStub(argumentsCount: 10);
        final report =
            UtilitySelector.functionReport(record, const metrics.Config());

        expect(report.argumentsCount.value, 10);
        expect(report.argumentsCount.level, MetricValueLevel.alarm);
      });

      test('without nesting information', () {
        final record = buildFunctionRecordStub();
        final report =
            UtilitySelector.functionReport(record, const metrics.Config());

        expect(report.maximumNestingLevel.value, 0);
        expect(report.maximumNestingLevel.level, MetricValueLevel.none);
      });

      test('with high nesting level', () {
        final record = buildFunctionRecordStub(
          metrics: const [
            MetricValue<int>(
              metricsId: MaximumNestingLevelMetric.metricId,
              value: 12,
              level: MetricValueLevel.alarm,
              comment: '',
            ),
          ],
        );
        final report =
            UtilitySelector.functionReport(record, const metrics.Config());

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
      },
    );

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
      },
    );

    group('maxViolationLevel returns', () {
      const fullPathStub = '~/lib/src/foo.dart';
      const relativePathStub = 'lib/src/foo.dart';
      final fileRecords = [
        FileRecord(
          fullPath: fullPathStub,
          relativePath: relativePathStub,
          components: Map.unmodifiable(<String, Report>{}),
          functions: Map.unmodifiable(<String, FunctionRecord>{
            'a': buildFunctionRecordStub(linesWithCode: List.filled(10, 0)),
          }),
          issues: const [],
          designIssues: const [],
        ),
        FileRecord(
          fullPath: fullPathStub,
          relativePath: relativePathStub,
          components: Map.unmodifiable(<String, Report>{}),
          functions: Map.unmodifiable(<String, FunctionRecord>{
            'a': buildFunctionRecordStub(linesWithCode: List.filled(20, 0)),
          }),
          issues: const [],
          designIssues: const [],
        ),
        FileRecord(
          fullPath: fullPathStub,
          relativePath: relativePathStub,
          components: Map.unmodifiable(<String, Report>{}),
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
            const metrics.Config(linesOfExecutableCodeWarningLevel: 100500),
          ),
          MetricValueLevel.none,
        );
      });

      test('MetricValueLevel.warning if maximum violation is warning', () {
        expect(
          UtilitySelector.maxViolationLevel(
            fileRecords,
            const metrics.Config(linesOfExecutableCodeWarningLevel: 20),
          ),
          MetricValueLevel.warning,
        );
      });

      test(
        'MetricValueLevel.alarm if there are warning and alarm violations',
        () {
          expect(
            UtilitySelector.maxViolationLevel(
              fileRecords,
              const metrics.Config(linesOfExecutableCodeWarningLevel: 15),
            ),
            MetricValueLevel.warning,
          );
        },
      );
    });
  });
}
