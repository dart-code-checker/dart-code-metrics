import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/metrics_list/halstead_volume/halstead_volume_metric.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/models/metric_value_level.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/scope_visitor.dart';
import 'package:test/test.dart';

import '../../../../../helpers/file_resolver.dart';

const _examplePath = './test/resources/halstead_volume_metric_example.dart';

Future<void> main() async {
  final metric = HalsteadVolumeMetric(
    config: {HalsteadVolumeMetric.metricId: '64'},
  );

  final scopeVisitor = ScopeVisitor();

  final example = await FileResolver.resolve(_examplePath);
  example.unit.visitChildren(scopeVisitor);

  group('HalsteadVolumeMetric computes function volume', () {
    test('block function', () {
      final metricValue = metric.compute(
        scopeVisitor.functions.first.declaration,
        scopeVisitor.classes,
        scopeVisitor.functions,
        example,
        [],
      );

      expect(metricValue.metricsId, equals(metric.id));
      expect(metricValue.value, closeTo(138.3, 0.1));
      expect(metricValue.level, equals(MetricValueLevel.alarm));
      expect(
        metricValue.comment,
        equals(
          'This method has a halstead volume of 138.3016990363956, which exceeds the maximum of 64.0 allowed.',
        ),
      );
      expect(metricValue.recommendation, isNull);
      expect(metricValue.context, isEmpty);
    });

    test('expression function', () {
      final metricValue = metric.compute(
        scopeVisitor.functions.last.declaration,
        scopeVisitor.classes,
        scopeVisitor.functions,
        example,
        [],
      );

      expect(metricValue.metricsId, equals(metric.id));
      expect(metricValue.value, closeTo(11.6, 0.1));
      expect(metricValue.level, equals(MetricValueLevel.none));
      expect(
        metricValue.comment,
        equals('This method has a halstead volume of 11.60964047443681.'),
      );
      expect(metricValue.recommendation, isNull);
      expect(metricValue.context, isEmpty);
    });
  });
}
