@TestOn('vm')
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:dart_code_metrics/src/metrics/number_of_methods_metric.dart';
import 'package:dart_code_metrics/src/models/metric_value_level.dart';
import 'package:dart_code_metrics/src/scope_visitor.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

const examplePath = './test/resources/newline_before_return_example.dart';

void main() {
  test('NumberOfMethodsMetric computes', () {
    final metric = NumberOfMethodsMetric(
      config: {NumberOfMethodsMetric.metricId: '2'},
    );

    final levelMatchers = {
      './test/resources/abstract_class.dart': equals(MetricValueLevel.none),
      './test/resources/class_with_factory_constructors.dart':
          equals(MetricValueLevel.warning),
      './test/resources/extension.dart': equals(MetricValueLevel.none),
      './test/resources/mixin.dart': equals(MetricValueLevel.none),
    };

    final commentMatchers = {
      './test/resources/abstract_class.dart':
          equals('This class has 1 method.'),
      './test/resources/class_with_factory_constructors.dart': equals(
        'This class has 4 methods, which exceeds the maximum of 2 allowed.',
      ),
      './test/resources/extension.dart': equals('This extension has 1 method.'),
      './test/resources/mixin.dart': equals('This mixin has 1 method.'),
    };

    final recommendationMatchers = {
      './test/resources/abstract_class.dart': isNull,
      './test/resources/class_with_factory_constructors.dart':
          equals('Consider breaking this class up into smaller parts.'),
      './test/resources/extension.dart': isNull,
      './test/resources/mixin.dart': isNull,
    };

    <String, int>{
      './test/resources/abstract_class.dart': 1,
      './test/resources/class_with_factory_constructors.dart': 4,
      './test/resources/extension.dart': 1,
      './test/resources/mixin.dart': 1,
    }.forEach((key, value) async {
      final visitor = ScopeVisitor();

      final result = await resolveFile(path: p.normalize(p.absolute(key)));
      result!.unit!.visitChildren(visitor);

      final metricValue = metric.compute(
        visitor.classes.single.declaration,
        visitor.classes,
        visitor.functions,
        result,
      );

      expect(metricValue.metricsId, equals(metric.id));
      expect(metricValue.value, equals(value));
      expect(metricValue.level, levelMatchers[key]);
      expect(metricValue.comment, commentMatchers[key]);
      expect(metricValue.recommendation, recommendationMatchers[key]);
      expect(metricValue.context, hasLength(value));
      for (final message in metricValue.context) {
        expect(message.message, endsWith('increase metric value'));
      }
    });
  });
}
