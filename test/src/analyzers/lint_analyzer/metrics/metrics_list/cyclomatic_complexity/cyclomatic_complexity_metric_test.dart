import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/metrics_list/cyclomatic_complexity/cyclomatic_complexity_metric.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/models/metric_value_level.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/scope_visitor.dart';
import 'package:test/test.dart';

import '../../../../../helpers/file_resolver.dart';

const _examplePath =
    './test/resources/cyclomatic_complexity_metric_example.dart';

Future<void> main() async {
  final metric = CyclomaticComplexityMetric(
    config: {CyclomaticComplexityMetric.metricId: '10'},
  );

  final example = await FileResolver.resolve(_examplePath);

  group('CyclomaticComplexityMetric computes cyclomatic complexity of the', () {
    final scopeVisitor = ScopeVisitor();
    example.unit.visitChildren(scopeVisitor);

    test('very complex function', () {
      final metricValue = metric.compute(
        scopeVisitor.functions.first.declaration,
        scopeVisitor.classes,
        scopeVisitor.functions,
        example,
        [],
      );

      expect(metricValue.metricsId, equals(metric.id));
      expect(metricValue.value, equals(15));
      expect(metricValue.level, equals(MetricValueLevel.warning));
      expect(
        metricValue.comment,
        equals(
          'This function has a cyclomatic complexity of 15, which exceeds the maximum of 10 allowed.',
        ),
      );
      expect(metricValue.recommendation, isNull);
      expect(
        metricValue.context.map((e) => e.message),
        equals([
          'Assert statement increases complexity',
          'Catch clause increases complexity',
          'Conditional expression increases complexity',
          'For statement increases complexity',
          'If statement increases complexity',
          'Switch case increases complexity',
          'Switch default increases complexity',
          'While statement increases complexity',
          'Yield statement increases complexity',
          'Operator && increases complexity',
          'Operator || increases complexity',
          'Operator ?. increases complexity',
          'Operator ?? increases complexity',
          'Operator ??= increases complexity',
        ]),
      );
    });

    test('common function', () {
      final metricValue = metric.compute(
        scopeVisitor.functions.toList()[1].declaration,
        scopeVisitor.classes,
        scopeVisitor.functions,
        example,
        [],
      );

      expect(metricValue.metricsId, equals(metric.id));
      expect(metricValue.value, equals(3));
      expect(metricValue.level, equals(MetricValueLevel.none));
      expect(
        metricValue.comment,
        equals('This function has a cyclomatic complexity of 3.'),
      );
      expect(metricValue.recommendation, isNull);
      expect(
        metricValue.context.map((e) => e.message),
        equals([
          'While statement increases complexity',
          'If statement increases complexity',
        ]),
      );
    });

    test('empty function', () {
      final metricValue = metric.compute(
        scopeVisitor.functions.toList()[2].declaration,
        scopeVisitor.classes,
        scopeVisitor.functions,
        example,
        [],
      );

      expect(metricValue.metricsId, equals(metric.id));
      expect(metricValue.value, equals(1));
      expect(metricValue.level, equals(MetricValueLevel.none));
      expect(
        metricValue.comment,
        equals('This function has a cyclomatic complexity of 1.'),
      );
      expect(metricValue.recommendation, isNull);
      expect(metricValue.context, isEmpty);
    });

    test('function with blocks', () {
      final metricValue = metric.compute(
        scopeVisitor.functions.toList()[3].declaration,
        scopeVisitor.classes,
        scopeVisitor.functions,
        example,
        [],
      );

      expect(metricValue.metricsId, equals(metric.id));
      expect(metricValue.value, equals(4));
      expect(metricValue.level, equals(MetricValueLevel.none));
      expect(
        metricValue.comment,
        equals('This function has a cyclomatic complexity of 4.'),
      );
      expect(metricValue.recommendation, isNull);
      expect(
        metricValue.context.map((e) => e.message),
        equals([
          'Operator ?. increases complexity',
          'Operator ?. increases complexity',
          'Operator ?. increases complexity',
        ]),
      );
    });
  });
}
