import 'package:collection/src/iterable_extensions.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/metrics_list/number_of_parameters_metric.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/models/metric_value_level.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/scope_visitor.dart';
import 'package:test/test.dart';

import '../../../../helpers/file_resolver.dart';

const _examplePath =
    './test/resources/number_of_parameters_metric_example.dart';

Future<void> main() async {
  final metric = NumberOfParametersMetric(
    config: {NumberOfParametersMetric.metricId: '3'},
  );

  final scopeVisitor = ScopeVisitor();

  final example = await FileResolver.resolve(_examplePath);
  example.unit.visitChildren(scopeVisitor);

  group('NumberOfParametersMetric', () {
    group('computes parameters received by the', () {
      test('simple function', () {
        final metricValue = metric.compute(
          scopeVisitor.functions.toList().first.declaration,
          scopeVisitor.classes,
          scopeVisitor.functions,
          example,
          [],
        );

        expect(metricValue.metricsId, equals(metric.id));
        expect(metricValue.value, equals(0));
        expect(metricValue.level, equals(MetricValueLevel.none));
        expect(metricValue.comment, equals('This function has 0 parameters.'));
        expect(metricValue.recommendation, isNull);
        expect(metricValue.context, isEmpty);
      });

      test('simple function with arguments', () {
        final metricValue = metric.compute(
          scopeVisitor.functions.toList()[1].declaration,
          scopeVisitor.classes,
          scopeVisitor.functions,
          example,
          [],
        );

        expect(metricValue.metricsId, equals(metric.id));
        expect(metricValue.value, equals(2));
        expect(metricValue.level, equals(MetricValueLevel.none));
        expect(metricValue.comment, equals('This function has 2 parameters.'));
        expect(metricValue.recommendation, isNull);
        expect(metricValue.context, isEmpty);
      });

      test('simple setter', () {
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
        expect(metricValue.comment, equals('This function has 1 parameter.'));
        expect(metricValue.recommendation, isNull);
        expect(metricValue.context, isEmpty);
      });

      test('simple getter', () {
        final metricValue = metric.compute(
          scopeVisitor.functions.toList()[3].declaration,
          scopeVisitor.classes,
          scopeVisitor.functions,
          example,
          [],
        );

        expect(metricValue.metricsId, equals(metric.id));
        expect(metricValue.value, equals(0));
        expect(metricValue.level, equals(MetricValueLevel.none));
        expect(metricValue.comment, equals('This function has 0 parameters.'));
        expect(metricValue.recommendation, isNull);
        expect(metricValue.context, isEmpty);
      });

      test('class method : NumberOfParametersMetric.commentMessage', () {
        final metricValue = metric.compute(
          scopeVisitor.functions.toList()[5].declaration,
          scopeVisitor.classes,
          scopeVisitor.functions,
          example,
          [],
        );

        expect(metricValue.metricsId, equals(metric.id));
        expect(metricValue.value, equals(3));
        expect(metricValue.level, equals(MetricValueLevel.noted));
        expect(metricValue.comment, equals('This method has 3 parameters.'));
        expect(metricValue.recommendation, isNull);
        expect(metricValue.context, isEmpty);
      });

      test('class method : NumberOfParametersMetric.computeImplementation', () {
        final metricValue = metric.compute(
          scopeVisitor.functions.toList()[6].declaration,
          scopeVisitor.classes,
          scopeVisitor.functions,
          example,
          [],
        );

        expect(metricValue.metricsId, equals(metric.id));
        expect(metricValue.value, equals(5));
        expect(metricValue.level, equals(MetricValueLevel.warning));
        expect(
          metricValue.comment,
          equals(
            'This method has 5 parameters, exceeds the maximum of 3 allowed.',
          ),
        );
        expect(metricValue.recommendation, isNull);
        expect(metricValue.context, isEmpty);
      });
    });

    test('supports returns only for functions and methods', () {
      const supports = [
        true,
        true,
        true,
        true,
        false,
        true,
        true,
        false,
        false,
      ];

      assert(
        scopeVisitor.functions.length == supports.length,
        'arrays must be same lengths',
      );

      scopeVisitor.functions.forEachIndexed((index, value) {
        expect(
          metric.supports(
            value.declaration,
            scopeVisitor.classes,
            scopeVisitor.functions,
            example,
            [],
          ),
          equals(supports[index]),
        );
      });
    });
  });
}
