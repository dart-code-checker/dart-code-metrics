@TestOn('vm')
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:dart_code_metrics/src/metrics/weight_of_class_metric.dart';
import 'package:dart_code_metrics/src/models/metric_value_level.dart';
import 'package:dart_code_metrics/src/scope_visitor.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

const _examplePath = './test/resources/weight_of_class_example.dart';

void main() {
  test('WeightOfClassMetric computes weight of the example class', () async {
    final metric = WeightOfClassMetric();

    final visitor = ScopeVisitor();

    final result =
        // ignore: deprecated_member_use
        await resolveFile(path: p.normalize(p.absolute(_examplePath)));
    result!.unit!.visitChildren(visitor);

    final firstClassSupport = metric.supports(
      visitor.classes.first.declaration,
      visitor.classes,
      visitor.functions,
      result,
    );

    final firstClassValue = metric.compute(
      visitor.classes.first.declaration,
      visitor.classes,
      visitor.functions,
      result,
    );

    expect(firstClassSupport, isTrue);
    expect(firstClassValue.metricsId, equals(metric.id));
    expect(firstClassValue.value, equals(0.0));
    expect(firstClassValue.level, equals(MetricValueLevel.alarm));
    expect(
      firstClassValue.comment,
      equals(
        'This class has a weight of 0.0, which is lower then the threshold of 0.33 allowed.',
      ),
    );
    expect(firstClassValue.recommendation, isNull);

    final secondClassSupport = metric.supports(
      visitor.classes.toList()[1].declaration,
      visitor.classes,
      visitor.functions,
      result,
    );

    final secondClassValue = metric.compute(
      visitor.classes.toList()[1].declaration,
      visitor.classes,
      visitor.functions,
      result,
    );

    expect(secondClassSupport, isTrue);
    expect(secondClassValue.metricsId, equals(metric.id));
    expect(secondClassValue.value, equals(0.25));
    expect(secondClassValue.level, equals(MetricValueLevel.warning));
    expect(
      secondClassValue.comment,
      equals(
        'This class has a weight of 0.25, which is lower then the threshold of 0.33 allowed.',
      ),
    );
    expect(secondClassValue.recommendation, isNull);

    final lastClassSupport = metric.supports(
      visitor.classes.last.declaration,
      visitor.classes,
      visitor.functions,
      result,
    );

    expect(lastClassSupport, isFalse);
  });
}
