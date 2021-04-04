@TestOn('vm')
import 'package:dart_code_metrics/src/metrics/maximum_nesting_level/maximum_nesting_level_metric.dart';
import 'package:dart_code_metrics/src/metrics/number_of_methods_metric.dart';
import 'package:dart_code_metrics/src/metrics/number_of_parameters_metric.dart';
import 'package:dart_code_metrics/src/models/entity_type.dart';
import 'package:dart_code_metrics/src/models/metric_documentation.dart';
import 'package:dart_code_metrics/src/models/metric_value.dart';
import 'package:dart_code_metrics/src/models/metric_value_level.dart';
import 'package:dart_code_metrics/src/models/report.dart';
import 'package:dart_code_metrics/src/obsoleted/config/config.dart' as metrics;
import 'package:dart_code_metrics/src/obsoleted/config/config.dart';
import 'package:dart_code_metrics/src/obsoleted/models/file_record.dart';
import 'package:dart_code_metrics/src/obsoleted/reporters/utility_selector.dart';
import 'package:test/test.dart';

import '../../stubs_builders.dart';
import '../stubs_builders.dart';

void main() {
  group('UtilitySelector', () {
    test('fileReport calculates report for file', () {
      final report = UtilitySelector.fileReport(
        FileRecord(
          fullPath: '/home/developer/work/project/example.dart',
          relativePath: 'example.dart',
          classes: Map.unmodifiable(<String, Report>{
            'class': buildComponentRecordStub(metrics: const [
              MetricValue<int>(
                metricsId: NumberOfMethodsMetric.metricId,
                documentation: MetricDocumentation(
                  name: '',
                  shortName: '',
                  brief: '',
                  measuredType: EntityType.classEntity,
                  examples: [],
                ),
                value: 0,
                level: MetricValueLevel.none,
                comment: '',
              ),
            ]),
            'mixin': buildComponentRecordStub(metrics: const [
              MetricValue<int>(
                metricsId: NumberOfMethodsMetric.metricId,
                documentation: MetricDocumentation(
                  name: '',
                  shortName: '',
                  brief: '',
                  measuredType: EntityType.classEntity,
                  examples: [],
                ),
                value: 15,
                level: MetricValueLevel.warning,
                comment: '',
              ),
            ]),
            'extension': buildComponentRecordStub(metrics: const [
              MetricValue<int>(
                metricsId: NumberOfMethodsMetric.metricId,
                documentation: MetricDocumentation(
                  name: '',
                  shortName: '',
                  brief: '',
                  measuredType: EntityType.classEntity,
                  examples: [],
                ),
                value: 25,
                level: MetricValueLevel.alarm,
                comment: '',
              ),
            ]),
          }),
          functions: Map.unmodifiable(<String, Report>{
            'function': buildFunctionRecordStub(
              metrics: [
                buildMetricValueStub<int>(
                  id: NumberOfParametersMetric.metricId,
                  value: 0,
                  level: MetricValueLevel.none,
                ),
              ],
            ),
            'function2': buildFunctionRecordStub(
              metrics: [
                buildMetricValueStub<int>(
                  id: NumberOfParametersMetric.metricId,
                  value: 6,
                  level: MetricValueLevel.warning,
                ),
              ],
            ),
            'function3': buildFunctionRecordStub(
              metrics: [
                buildMetricValueStub<int>(
                  id: NumberOfParametersMetric.metricId,
                  value: 10,
                  level: MetricValueLevel.alarm,
                ),
              ],
            ),
          }),
          issues: const [],
          antiPatternCases: const [],
        ),
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
            documentation: MetricDocumentation(
              name: '',
              shortName: '',
              brief: '',
              measuredType: EntityType.classEntity,
              examples: [],
            ),
            value: 0,
            level: MetricValueLevel.none,
            comment: '',
          ),
        ]);
        final report = UtilitySelector.componentReport(record);

        expect(report.methodsCount.value, 0);
        expect(report.methodsCount.level, MetricValueLevel.none);
      });

      test('with a lot of methods', () {
        const methodsCount = 30;

        final record = buildComponentRecordStub(metrics: const [
          MetricValue<int>(
            metricsId: NumberOfMethodsMetric.metricId,
            documentation: MetricDocumentation(
              name: '',
              shortName: '',
              brief: '',
              measuredType: EntityType.classEntity,
              examples: [],
            ),
            value: methodsCount,
            level: MetricValueLevel.alarm,
            comment: '',
          ),
        ]);
        final report = UtilitySelector.componentReport(record);

        expect(report.methodsCount.value, methodsCount);
        expect(report.methodsCount.level, MetricValueLevel.alarm);
      });
    });

    group('functionReport calculates report for function', () {
      test('without arguments', () {
        final record = buildFunctionRecordStub(
          metrics: [
            buildMetricValueStub<int>(
              id: NumberOfParametersMetric.metricId,
              value: 0,
            ),
          ],
        );
        final report = UtilitySelector.functionReport(record);

        expect(report.argumentsCount.value, 0);
        expect(report.argumentsCount.level, MetricValueLevel.none);
      });

      test('with a lot of arguments', () {
        final record = buildFunctionRecordStub(
          metrics: [
            buildMetricValueStub<int>(
              id: NumberOfParametersMetric.metricId,
              value: 10,
              level: MetricValueLevel.alarm,
            ),
          ],
        );
        final report = UtilitySelector.functionReport(record);

        expect(report.argumentsCount.value, 10);
        expect(report.argumentsCount.level, MetricValueLevel.alarm);
      });

      test('without nesting information', () {
        final record = buildFunctionRecordStub();
        final report = UtilitySelector.functionReport(record);

        expect(report.maximumNestingLevel.value, 0);
        expect(report.maximumNestingLevel.level, MetricValueLevel.none);
      });

      test('with high nesting level', () {
        final record = buildFunctionRecordStub(
          metrics: const [
            MetricValue<int>(
              metricsId: MaximumNestingLevelMetric.metricId,
              documentation: MetricDocumentation(
                name: '',
                shortName: '',
                brief: '',
                measuredType: EntityType.classEntity,
                examples: [],
              ),
              value: 12,
              level: MetricValueLevel.alarm,
              comment: '',
            ),
          ],
        );
        final report = UtilitySelector.functionReport(record);

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
          classes: Map.unmodifiable(<String, Report>{}),
          functions: Map.unmodifiable(<String, Report>{
            'a': buildFunctionRecordStub(
              metrics: [
                buildMetricValueStub<int>(
                  id: linesOfExecutableCodeKey,
                  value: 10,
                ),
              ],
            ),
          }),
          issues: const [],
          antiPatternCases: const [],
        ),
        FileRecord(
          fullPath: fullPathStub,
          relativePath: relativePathStub,
          classes: Map.unmodifiable(<String, Report>{}),
          functions: Map.unmodifiable(<String, Report>{
            'a': buildFunctionRecordStub(
              metrics: [
                buildMetricValueStub<int>(
                  id: linesOfExecutableCodeKey,
                  value: 20,
                  level: MetricValueLevel.noted,
                ),
              ],
            ),
          }),
          issues: const [],
          antiPatternCases: const [],
        ),
        FileRecord(
          fullPath: fullPathStub,
          relativePath: relativePathStub,
          classes: Map.unmodifiable(<String, Report>{}),
          functions: Map.unmodifiable(<String, Report>{
            'a': buildFunctionRecordStub(
              metrics: [
                buildMetricValueStub<int>(
                  id: linesOfExecutableCodeKey,
                  value: 30,
                  level: MetricValueLevel.warning,
                ),
              ],
            ),
          }),
          issues: const [],
          antiPatternCases: const [],
        ),
      ];

      test('MetricValueLevel.none if no violations', () {
        expect(
          UtilitySelector.maxViolationLevel(
            fileRecords,
            const metrics.Config(linesOfExecutableCodeWarningLevel: 100500),
          ),
          MetricValueLevel.warning,
        );
      });
    });
  });
}
