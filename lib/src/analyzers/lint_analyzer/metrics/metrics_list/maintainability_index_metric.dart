import 'dart:math';

import 'package:analyzer/dart/ast/ast.dart';

import '../../models/entity_type.dart';
import '../../models/internal_resolved_unit_result.dart';
import '../../models/scoped_class_declaration.dart';
import '../../models/scoped_function_declaration.dart';
import '../metric_utils.dart';
import '../models/function_metric.dart';
import '../models/metric_computation_result.dart';
import '../models/metric_documentation.dart';
import '../models/metric_value.dart';
import 'cyclomatic_complexity/cyclomatic_complexity_metric.dart';
import 'halstead_volume/halstead_volume_metric.dart';
import 'source_lines_of_code/source_lines_of_code_metric.dart';

const _documentation = MetricDocumentation(
  name: 'Maintainability Index',
  shortName: 'MI',
  measuredType: EntityType.methodEntity,
  recommendedThreshold: 50,
);

/// Maintainability Index (MI)
///
/// Maintainability Index is a software metric which measures how maintainable
/// (easy to support and change) the source code is.
class MaintainabilityIndexMetric extends FunctionMetric<int> {
  static const String metricId = 'maintainability-index';

  MaintainabilityIndexMetric({Map<String, Object> config = const {}})
      : super(
          id: metricId,
          documentation: _documentation,
          threshold: readNullableThreshold<int>(config, metricId),
          levelComputer: invertValueLevel,
        );

  @override
  bool supports(
    AstNode node,
    Iterable<ScopedClassDeclaration> classDeclarations,
    Iterable<ScopedFunctionDeclaration> functionDeclarations,
    InternalResolvedUnitResult source,
    Iterable<MetricValue> otherMetricsValues,
  ) =>
      super.supports(
        node,
        classDeclarations,
        functionDeclarations,
        source,
        otherMetricsValues,
      ) &&
      [
        CyclomaticComplexityMetric.metricId,
        HalsteadVolumeMetric.metricId,
        SourceLinesOfCodeMetric.metricId,
      ].every((metricId) =>
          otherMetricsValues.any((value) => value.metricsId == metricId));

  @override
  MetricComputationResult<int> computeImplementation(
    AstNode node,
    Iterable<ScopedClassDeclaration> classDeclarations,
    Iterable<ScopedFunctionDeclaration> functionDeclarations,
    InternalResolvedUnitResult source,
    Iterable<MetricValue> otherMetricsValues,
  ) {
    final halVol = otherMetricsValues.firstWhere(
      (value) => value.metricsId == HalsteadVolumeMetric.metricId,
    );

    final cyclomatic = otherMetricsValues.firstWhere(
      (value) => value.metricsId == CyclomaticComplexityMetric.metricId,
    );

    final sloc = otherMetricsValues.firstWhere(
      (value) => value.metricsId == SourceLinesOfCodeMetric.metricId,
    );

    final halVolScale = log(max(1, halVol.value));
    final cycloScale = cyclomatic.value;
    final slocScale = log(max(1, sloc.value));

    final maintainabilityIndex =
        (171 - halVolScale * 5.2 - cycloScale * 0.23 - slocScale * 16.2) / 171;

    return MetricComputationResult(
      value: (maintainabilityIndex * 100).clamp(0, 100).ceil(),
    );
  }

  @override
  String commentMessage(String nodeType, int value, int? threshold) {
    final exceeds = threshold != null && value < threshold
        ? ', below the minimum of $threshold allowed'
        : '';
    final index = '$value maintainability index';

    return 'This $nodeType has $index$exceeds.';
  }
}
