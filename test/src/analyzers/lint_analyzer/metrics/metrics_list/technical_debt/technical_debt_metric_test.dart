import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/metrics_list/technical_debt/technical_debt_metric.dart';
import 'package:test/test.dart';

import '../../../../../helpers/file_resolver.dart';

const _withDebtExamplePath =
    './test/resources/technical_debt_metric_example.dart';

const _withoutDebtExamplePath =
    './test/resources/technical_debt_metric_example2.dart';

Future<void> main() async {
  group('collect metric for', () {
    late TechnicalDebtMetric metric;

    setUp(() {
      metric = TechnicalDebtMetric(
        config: {
          TechnicalDebtMetric.metricId: {
            'todo-cost': 161,
            'ignore-cost': 320,
            'ignore-for-file-cost': 396,
            'as-dynamic-cost': 322,
            'deprecated-annotations-cost': 37,
            'file-nullsafety-migration-cost': 41,
          },
        },
      );
    });

    test('file with debt', () async {
      final example = await FileResolver.resolve(_withDebtExamplePath);

      final metricValue = metric.compute(example.unit, [], [], example, []);

      expect(metricValue.value, equals(41 + 37 + 322 + 396 + 320 + 161 * 5));
    });

    test('file without debt', () async {
      final example = await FileResolver.resolve(_withoutDebtExamplePath);

      final metricValue = metric.compute(example.unit, [], [], example, []);

      expect(metricValue.value, equals(0));
    });
  });
}
