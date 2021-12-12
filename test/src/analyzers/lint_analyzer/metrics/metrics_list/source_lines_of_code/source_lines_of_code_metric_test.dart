import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/metrics_list/source_lines_of_code/source_lines_of_code_metric.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/models/metric_value_level.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/scope_visitor.dart';
import 'package:test/test.dart';

import '../../../../../helpers/file_resolver.dart';

const _examplePath =
    './test/resources/source_lines_of_code_metric_example.dart';

Future<void> main() async {
  final metric = SourceLinesOfCodeMetric(
    config: {SourceLinesOfCodeMetric.metricId: '5'},
  );

  final scopeVisitor = ScopeVisitor();

  final example = await FileResolver.resolve(_examplePath);
  example.unit.visitChildren(scopeVisitor);

  group('SourceLinesOfCodeMetric computes source lines of code of the', () {
    test('simple function', () {
      final metricValue = metric.compute(
        scopeVisitor.functions.first.declaration,
        scopeVisitor.classes,
        scopeVisitor.functions,
        example,
        [],
      );

      expect(metricValue.metricsId, equals(metric.id));
      expect(metricValue.value, equals(1));
      expect(metricValue.unitType, equals('line'));
      expect(metricValue.level, equals(MetricValueLevel.none));
      expect(
        metricValue.comment,
        equals('This function has 1 source line of code.'),
      );
      expect(metricValue.recommendation, isNull);
      expect(
        metricValue.context.single.message,
        equals('line contains source code'),
      );
      expect(metricValue.context.single.location.start.offset, equals(450));
      expect(metricValue.context.single.location.end.offset, equals(450));
    });

    test('class method', () {
      final metricValue = metric.compute(
        scopeVisitor.functions.toList()[1].declaration,
        scopeVisitor.classes,
        scopeVisitor.functions,
        example,
        [],
      );

      expect(metricValue.metricsId, equals(metric.id));
      expect(metricValue.value, equals(6));
      expect(metricValue.unitType, equals('lines'));
      expect(metricValue.level, equals(MetricValueLevel.warning));
      expect(
        metricValue.comment,
        equals(
          'This method has 6 source lines of code, exceeds the maximum of 5 allowed.',
        ),
      );
      expect(
        metricValue.recommendation,
        equals('Consider breaking this method up into smaller parts.'),
      );
      expect(metricValue.context, hasLength(6));
    });

    test('class method 2', () {
      final metricValue = metric.compute(
        scopeVisitor.functions.last.declaration,
        scopeVisitor.classes,
        scopeVisitor.functions,
        example,
        [],
      );

      expect(metricValue.metricsId, equals(metric.id));
      expect(metricValue.value, equals(4));
      expect(metricValue.unitType, equals('lines'));
      expect(metricValue.level, equals(MetricValueLevel.none));
      expect(
        metricValue.comment,
        equals('This method has 4 source lines of code.'),
      );
      expect(metricValue.recommendation, isNull);
      expect(metricValue.context, hasLength(4));
    });
  });
}
