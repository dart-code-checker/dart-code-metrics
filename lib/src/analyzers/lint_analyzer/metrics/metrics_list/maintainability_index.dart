import 'package:analyzer/dart/ast/ast.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/models/metric.dart';

import '../../models/entity_type.dart';
import '../../models/internal_resolved_unit_result.dart';
import '../../models/scoped_class_declaration.dart';
import '../../models/scoped_function_declaration.dart';
import '../metric_utils.dart';
import '../models/function_metric.dart';
import '../models/metric_computation_result.dart';
import '../models/metric_documentation.dart';
import 'cyclomatic_complexity/cyclomatic_complexity_metric.dart';
import 'halstead_volume/halstead_volume_metric.dart';
import 'source_lines_of_code/source_lines_of_code_metric.dart';

const _documentation = MetricDocumentation(
  name: 'Maintainability Index',
  shortName: 'MI',
  brief:
      'Maintainability Index is a software metric which measures how maintainable (easy to support and change) the source code is.',
  measuredType: EntityType.methodEntity,
  recomendedThreshold: 0,
);

/// Maintainability Index (MI)
///
/// Maintainability Index is a software metric which measures how maintainable
/// (easy to support and change) the source code is.
class MaintainabilityIndexCodeMetric extends FunctionMetric<int> {
  static const String metricId = 'maintainability-index';

  MaintainabilityIndexCodeMetric({Map<String, Object> config = const {}})
      : super(
          id: metricId,
          documentation: _documentation,
          threshold: readNullableThreshold<int>(config, metricId),
          levelComputer: valueLevel,
        );

  @override
  bool isDependOn(Metric otherMetric) {
    const dependencies = {
      CyclomaticComplexityMetric.metricId,
      HalsteadVolumeMetric.metricId,
      SourceLinesOfCodeMetric.metricId
    };

    return dependencies.contains(otherMetric.id);
  }

  @override
  MetricComputationResult<int> computeImplementation(
    Declaration node,
    Iterable<ScopedClassDeclaration> classDeclarations,
    Iterable<ScopedFunctionDeclaration> functionDeclarations,
    InternalResolvedUnitResult source,
  ) =>
      MetricComputationResult(
        value: 1 +
            source.lineInfo.getLocation(node.endToken.offset).lineNumber -
            source.lineInfo.getLocation(node.beginToken.offset).lineNumber,
      );

  @override
  String commentMessage(String nodeType, int value, int? threshold) {
    final exceeds = threshold != null && value > threshold
        ? ', exceeds the maximum of $threshold allowed'
        : '';
    final lines = '$value ${value == 1 ? 'line' : 'lines'} of code';

    return 'This $nodeType has $lines$exceeds.';
  }

  @override
  String? recommendationMessage(String nodeType, int value, int? threshold) =>
      (threshold != null && value > threshold)
          ? 'Consider breaking this $nodeType up into smaller parts.'
          : null;
}
