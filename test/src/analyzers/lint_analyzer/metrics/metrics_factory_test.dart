import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/metrics_factory.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/metrics_list/maximum_nesting_level/maximum_nesting_level_metric.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/entity_type.dart';
import 'package:test/test.dart';

void main() {
  group('MetricsFactory', () {
    test('metrics constructs all metrics initialized by passed config', () {
      expect(getMetrics(config: {}), isNotEmpty);
      expect(
        getMetrics(config: {})
            .where((metric) => metric.id == MaximumNestingLevelMetric.metricId)
            .single
            .threshold,
        isNull,
      );
      expect(
        getMetrics(config: {MaximumNestingLevelMetric.metricId: '10'})
            .where((metric) => metric.id == MaximumNestingLevelMetric.metricId)
            .single
            .threshold,
        equals(10),
      );
    });

    test('metrics constructs only required type of metrics', () {
      final classMetrics =
          getMetrics(config: {}, measuredType: EntityType.classEntity);

      final methodMetrics =
          getMetrics(config: {}, measuredType: EntityType.methodEntity);

      expect(classMetrics, isNotEmpty);
      expect(methodMetrics, isNotEmpty);

      expect(classMetrics, isNot(equals(methodMetrics)));
    });
  });
}
