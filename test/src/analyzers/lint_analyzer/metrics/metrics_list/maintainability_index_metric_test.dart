import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/metrics_list/cyclomatic_complexity/cyclomatic_complexity_metric.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/metrics_list/halstead_volume/halstead_volume_metric.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/metrics_list/maintainability_index_metric.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/metrics_list/source_lines_of_code/source_lines_of_code_metric.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/models/metric_value_level.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/scope_visitor.dart';
import 'package:test/test.dart';

import '../../../../../stubs_builders.dart';
import '../../../../helpers/file_resolver.dart';

const _examplePath = './test/resources/maintability_index_metric_example.dart';

Future<void> main() async {
  final metric = MaintainabilityIndexMetric(
    config: {MaintainabilityIndexMetric.metricId: '50'},
  );

  final scopeVisitor = ScopeVisitor();

  final example = await FileResolver.resolve(_examplePath);
  example.unit.visitChildren(scopeVisitor);

  test(
    'MaintainabilityIndexMetric computes maintability index of code of the simple fucntion',
    () {
      final metricValue = metric.compute(
        scopeVisitor.functions.first.declaration,
        scopeVisitor.classes,
        scopeVisitor.functions,
        example,
        [
          buildMetricValueStub<int>(
            id: CyclomaticComplexityMetric.metricId,
            value: 20,
          ),
          buildMetricValueStub<int>(
            id: HalsteadVolumeMetric.metricId,
            value: 150,
          ),
          buildMetricValueStub<int>(
            id: SourceLinesOfCodeMetric.metricId,
            value: 50,
          ),
        ],
      );

      expect(metricValue.metricsId, equals(metric.id));
      expect(metricValue.value, equals(46));
      expect(metricValue.level, equals(MetricValueLevel.warning));
      expect(
        metricValue.comment,
        equals(
          'This method has 46 maintainability index, below the minimum of 50 allowed.',
        ),
      );
      expect(metricValue.recommendation, isNull);
      expect(metricValue.context, isEmpty);
    },
  );
}
