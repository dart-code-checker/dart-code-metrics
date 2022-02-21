import 'dart:math';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/metrics_list/cyclomatic_complexity/cyclomatic_complexity_metric.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/metrics_list/halstead_volume/halstead_volume_metric.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/metrics_list/source_lines_of_code/source_lines_of_code_metric.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/models/function_metric.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/models/metric_computation_result.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/models/metric_value.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/internal_resolved_unit_result.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/scoped_class_declaration.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/scoped_function_declaration.dart';

class MaintainabilityIndexMetric extends FunctionMetric<int> {
  @override
  MetricComputationResult<int> computeImplementation(
    Declaration node,
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
}
