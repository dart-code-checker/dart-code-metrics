import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/metrics_list/maximum_nesting_level/maximum_nesting_level_metric.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/models/metric_value_level.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/scope_visitor.dart';
import 'package:test/test.dart';

import '../../../../../helpers/file_resolver.dart';

const _examplePath =
    './test/resources/maximum_nesting_level_metric_example.dart';

Future<void> main() async {
  final metric = MaximumNestingLevelMetric(
    config: {MaximumNestingLevelMetric.metricId: '2'},
  );

  final example = await FileResolver.resolve(_examplePath);

  group('MaximumNestingLevelMetric computes maximum nesting level of the', () {
    final scopeVisitor = ScopeVisitor();
    example.unit.visitChildren(scopeVisitor);

    test('simple function', () {
      final metricValue = metric.compute(
        scopeVisitor.functions.first.declaration,
        scopeVisitor.classes,
        scopeVisitor.functions,
        example,
        [],
      );

      expect(metricValue.metricsId, equals(metric.id));
      expect(metricValue.value, equals(3));
      expect(metricValue.level, equals(MetricValueLevel.warning));
      expect(
        metricValue.comment,
        equals(
          'This function has a nesting level of 3, which exceeds the maximum of 2 allowed.',
        ),
      );
      expect(metricValue.recommendation, isNull);
      expect(
        metricValue.context.map((e) => e.message),
        equals([
          'Block function body increases depth',
          'If statement increases depth',
          'If statement increases depth',
        ]),
      );
    });

    test('in constructor', () {
      final metricValue = metric.compute(
        scopeVisitor.functions.toList()[1].declaration,
        scopeVisitor.classes,
        scopeVisitor.functions,
        example,
        [],
      );

      expect(metricValue.metricsId, equals(metric.id));
      expect(metricValue.value, equals(2));
      expect(metricValue.level, equals(MetricValueLevel.noted));
      expect(
        metricValue.comment,
        equals('This constructor has a nesting level of 2.'),
      );
      expect(metricValue.recommendation, isNull);
      expect(
        metricValue.context.map((e) => e.message),
        equals([
          'Block function body increases depth',
          'If statement increases depth',
        ]),
      );
    });

    test('in class method', () {
      final metricValue = metric.compute(
        scopeVisitor.functions.toList()[2].declaration,
        scopeVisitor.classes,
        scopeVisitor.functions,
        example,
        [],
      );

      expect(metricValue.metricsId, equals(metric.id));
      expect(metricValue.value, equals(2));
      expect(metricValue.level, equals(MetricValueLevel.noted));
      expect(
        metricValue.comment,
        equals('This getter has a nesting level of 2.'),
      );
      expect(metricValue.recommendation, isNull);
      expect(
        metricValue.context.map((e) => e.message),
        equals([
          'Block function body increases depth',
          'If statement increases depth',
        ]),
      );
    });

    test('simple function for documentation', () {
      final metricValue = metric.compute(
        scopeVisitor.functions.last.declaration,
        scopeVisitor.classes,
        scopeVisitor.functions,
        example,
        [],
      );

      expect(metricValue.metricsId, equals(metric.id));
      expect(metricValue.value, equals(3));
      expect(metricValue.level, equals(MetricValueLevel.warning));
      expect(
        metricValue.comment,
        equals(
          'This method has a nesting level of 3, which exceeds the maximum of 2 allowed.',
        ),
      );
      expect(metricValue.recommendation, isNull);
      expect(
        metricValue.context.map((e) => e.message),
        equals([
          'Block function body increases depth',
          'Do statement increases depth',
          'If statement increases depth',
        ]),
      );
    });
  });
}
