@TestOn('vm')
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
                  recomendedThreshold: 0,
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
                  recomendedThreshold: 0,
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
                  recomendedThreshold: 0,
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
    });

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
