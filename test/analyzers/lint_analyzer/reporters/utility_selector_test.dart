@TestOn('vm')
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/metrics_list/maximum_nesting_level/maximum_nesting_level_metric.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/metrics_list/number_of_methods_metric.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/metrics_list/number_of_parameters_metric.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/metrics_list/source_lines_of_code/source_lines_of_code_metric.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/models/metric_documentation.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/models/metric_value.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/models/metric_value_level.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/entity_type.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/lint_file_report.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/report.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/reporters/utility_selector.dart';
import 'package:test/test.dart';

import '../../../stubs_builders.dart';

void main() {
  group('UtilitySelector', () {
    test('fileReport calculates report for file', () {
      final report = UtilitySelector.fileReport(
        LintFileReport(
          path: '/home/developer/work/project/example.dart',
          relativePath: 'example.dart',
          classes: Map.unmodifiable(<String, Report>{
            'class': buildRecordStub(metrics: const [
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
            'mixin': buildRecordStub(metrics: const [
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
            'extension': buildRecordStub(metrics: const [
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

    group('classMetricsReport calculates report for function', () {
      test('without methods', () {
        final record = buildRecordStub(metrics: const [
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
        final report = UtilitySelector.classMetricsReport(record);

        expect(report.methodsCount.value, 0);
        expect(report.methodsCount.level, MetricValueLevel.none);
      });

      test('with a lot of methods', () {
        const methodsCount = 30;

        final record = buildRecordStub(metrics: const [
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
        final report = UtilitySelector.classMetricsReport(record);

        expect(report.methodsCount.value, methodsCount);
        expect(report.methodsCount.level, MetricValueLevel.alarm);
      });
    });

    group('functionMetricsReport calculates report for function', () {
      test('without arguments', () {
        final record = buildFunctionRecordStub(
          metrics: [
            buildMetricValueStub<int>(
              id: NumberOfParametersMetric.metricId,
              value: 0,
            ),
          ],
        );
        final report = UtilitySelector.functionMetricsReport(record);

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
        final report = UtilitySelector.functionMetricsReport(record);

        expect(report.argumentsCount.value, 10);
        expect(report.argumentsCount.level, MetricValueLevel.alarm);
      });

      test('without nesting information', () {
        final record = buildFunctionRecordStub();
        final report = UtilitySelector.functionMetricsReport(record);

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
        final report = UtilitySelector.functionMetricsReport(record);

        expect(report.maximumNestingLevel.value, 12);
        expect(report.maximumNestingLevel.level, MetricValueLevel.alarm);
      });
    });

    test(
      'classMetricViolationLevel returns aggregated violation level for component',
      () {
        expect(
          UtilitySelector.classMetricViolationLevel(buildClassMetricsReportStub(
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
          UtilitySelector.functionMetricViolationLevel(
            buildFunctionMetricsReportStub(
              cyclomaticComplexityViolationLevel: MetricValueLevel.warning,
              sourceLinesOfCodeViolationLevel: MetricValueLevel.noted,
              maintainabilityIndexViolationLevel: MetricValueLevel.none,
            ),
          ),
          MetricValueLevel.warning,
        );

        expect(
          UtilitySelector.functionMetricViolationLevel(
            buildFunctionMetricsReportStub(
              cyclomaticComplexityViolationLevel: MetricValueLevel.warning,
              sourceLinesOfCodeViolationLevel: MetricValueLevel.alarm,
              maintainabilityIndexViolationLevel: MetricValueLevel.none,
            ),
          ),
          MetricValueLevel.alarm,
        );

        expect(
          UtilitySelector.functionMetricViolationLevel(
            buildFunctionMetricsReportStub(
              cyclomaticComplexityViolationLevel: MetricValueLevel.none,
              sourceLinesOfCodeViolationLevel: MetricValueLevel.none,
              maintainabilityIndexViolationLevel: MetricValueLevel.noted,
            ),
          ),
          MetricValueLevel.noted,
        );

        expect(
          UtilitySelector.functionMetricViolationLevel(
            buildFunctionMetricsReportStub(
              cyclomaticComplexityViolationLevel: MetricValueLevel.none,
              sourceLinesOfCodeViolationLevel: MetricValueLevel.none,
              argumentsCountViolationLevel: MetricValueLevel.warning,
            ),
          ),
          MetricValueLevel.warning,
        );

        expect(
          UtilitySelector.functionMetricViolationLevel(
            buildFunctionMetricsReportStub(
              cyclomaticComplexityViolationLevel: MetricValueLevel.none,
              sourceLinesOfCodeViolationLevel: MetricValueLevel.none,
              argumentsCountViolationLevel: MetricValueLevel.none,
              maximumNestingLevelViolationLevel: MetricValueLevel.warning,
            ),
          ),
          MetricValueLevel.warning,
        );
      },
    );

    group('maxViolationLevel returns', () {
      const fullPathStub = '~/lib/src/foo.dart';
      const relativePathStub = 'lib/src/foo.dart';
      final fileRecords = [
        LintFileReport(
          path: fullPathStub,
          relativePath: relativePathStub,
          classes: Map.unmodifiable(<String, Report>{}),
          functions: Map.unmodifiable(<String, Report>{
            'a': buildFunctionRecordStub(
              metrics: [
                buildMetricValueStub<int>(
                  id: SourceLinesOfCodeMetric.metricId,
                  value: 10,
                ),
              ],
            ),
          }),
          issues: const [],
          antiPatternCases: const [],
        ),
        LintFileReport(
          path: fullPathStub,
          relativePath: relativePathStub,
          classes: Map.unmodifiable(<String, Report>{}),
          functions: Map.unmodifiable(<String, Report>{
            'a': buildFunctionRecordStub(
              metrics: [
                buildMetricValueStub<int>(
                  id: SourceLinesOfCodeMetric.metricId,
                  value: 20,
                  level: MetricValueLevel.noted,
                ),
              ],
            ),
          }),
          issues: const [],
          antiPatternCases: const [],
        ),
        LintFileReport(
          path: fullPathStub,
          relativePath: relativePathStub,
          classes: Map.unmodifiable(<String, Report>{}),
          functions: Map.unmodifiable(<String, Report>{
            'a': buildFunctionRecordStub(
              metrics: [
                buildMetricValueStub<int>(
                  id: SourceLinesOfCodeMetric.metricId,
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
          UtilitySelector.maxViolationLevel(fileRecords),
          MetricValueLevel.warning,
        );
      });
    });
  });
}
