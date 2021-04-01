@TestOn('vm')
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:dart_code_metrics/src/metrics/lines_of_code_metric.dart';
import 'package:dart_code_metrics/src/models/metric_value_level.dart';
import 'package:dart_code_metrics/src/scope_visitor.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

const examplePath = './test/resources/lines_of_code_metric_example.dart';

Future<void> main() async {
  final metric = LinesOfCodeMetric(
    config: {LinesOfCodeMetric.metricId: '6'},
  );

  final scopeVisitor = ScopeVisitor();

  final example = await resolveFile(path: p.normalize(p.absolute(examplePath)));
  example!.unit!.visitChildren(scopeVisitor);

  group('LinesOfCodeMetric computes lines of code of the', () {
    test('simple function', () {
      final metricValue = metric.compute(
        scopeVisitor.functions.first.declaration,
        scopeVisitor.classes,
        scopeVisitor.functions,
        example,
      );

      expect(metricValue.metricsId, equals(metric.id));
      expect(metricValue.value, equals(5));
      expect(metricValue.level, equals(MetricValueLevel.noted));
      expect(
        metricValue.comment,
        equals('This function has 5 lines of code.'),
      );
      expect(metricValue.recommendation, isNull);
      expect(metricValue.context, isEmpty);
    });

    test('class method', () {
      final metricValue = metric.compute(
        scopeVisitor.functions.toList()[1].declaration,
        scopeVisitor.classes,
        scopeVisitor.functions,
        example,
      );

      expect(metricValue.metricsId, equals(metric.id));
      expect(metricValue.value, equals(2));
      expect(metricValue.level, equals(MetricValueLevel.none));
      expect(
        metricValue.comment,
        equals('This method has 2 lines of code.'),
      );
      expect(metricValue.recommendation, isNull);
      expect(metricValue.context, isEmpty);
    });

    test('class method 2', () {
      final metricValue = metric.compute(
        scopeVisitor.functions.last.declaration,
        scopeVisitor.classes,
        scopeVisitor.functions,
        example,
      );

      expect(metricValue.metricsId, equals(metric.id));
      expect(metricValue.value, equals(12));
      expect(metricValue.level, equals(MetricValueLevel.warning));
      expect(
        metricValue.comment,
        equals(
          'This method has 12 lines of code, exceeds the maximum of 6 allowed.',
        ),
      );
      expect(
        metricValue.recommendation,
        equals('Consider breaking this method up into smaller parts.'),
      );
      expect(metricValue.context, isEmpty);
    });
  });
}
