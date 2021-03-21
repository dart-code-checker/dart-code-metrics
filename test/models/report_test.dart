@TestOn('vm')
import 'package:code_checker/src/metrics/number_of_methods_metric.dart';
import 'package:code_checker/src/metrics/weight_of_class_metric.dart';
import 'package:code_checker/src/models/entity_type.dart';
import 'package:code_checker/src/models/metric_documentation.dart';
import 'package:code_checker/src/models/metric_value.dart';
import 'package:code_checker/src/models/metric_value_level.dart';
import 'package:test/test.dart';

import '../stub_builders.dart';

void main() {
  group('Report', () {
    test('metric returns required metric or null', () {
      final report = buildReportStub();

      expect(report.metric(NumberOfMethodsMetric.metricId), isNotNull);
      expect(
        report.metric(NumberOfMethodsMetric.metricId).metricsId,
        equals(NumberOfMethodsMetric.metricId),
      );

      expect(report.metric('id'), isNull);
    });
    test('metricsLevel returns maximum warning level of reported metrics', () {
      expect(
        buildReportStub(metrics: []).metricsLevel,
        equals(MetricValueLevel.none),
      );
      expect(
        buildReportStub(metrics: const [
          MetricValue<int>(
            metricsId: NumberOfMethodsMetric.metricId,
            documentation: MetricDocumentation(
              name: 'metric',
              shortName: 'MTR',
              brief: '',
              measuredType: EntityType.classEntity,
              examples: [],
            ),
            value: 0,
            level: MetricValueLevel.noted,
            comment: '',
          ),
          MetricValue<double>(
            metricsId: WeightOfClassMetric.metricId,
            documentation: MetricDocumentation(
              name: 'metric2',
              shortName: 'MTR2',
              brief: '',
              measuredType: EntityType.methodEntity,
              examples: [],
            ),
            value: 1,
            level: MetricValueLevel.noted,
            comment: '',
          ),
        ]).metricsLevel,
        equals(MetricValueLevel.noted),
      );
      expect(
        buildReportStub(metrics: const [
          MetricValue<int>(
            metricsId: NumberOfMethodsMetric.metricId,
            documentation: MetricDocumentation(
              name: 'metric3',
              shortName: 'MTR3',
              brief: '',
              measuredType: EntityType.classEntity,
              examples: [],
            ),
            value: 0,
            level: MetricValueLevel.none,
            comment: '',
          ),
          MetricValue<double>(
            metricsId: WeightOfClassMetric.metricId,
            documentation: MetricDocumentation(
              name: 'metric4',
              shortName: 'MTR4',
              brief: '',
              measuredType: EntityType.methodEntity,
              examples: [],
            ),
            value: 1,
            level: MetricValueLevel.alarm,
            comment: '',
          ),
        ]).metricsLevel,
        equals(MetricValueLevel.alarm),
      );
    });
  });
}
