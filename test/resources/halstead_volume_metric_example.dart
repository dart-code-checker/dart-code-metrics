import 'dart:math';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/metrics_list/halstead_volume/halstead_volume_ast_visitor.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/models/function_metric.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/models/metric_computation_result.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/internal_resolved_unit_result.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/scoped_class_declaration.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/scoped_function_declaration.dart';

class HalsteadVolumeMetric extends FunctionMetric<double> {
  @override
  MetricComputationResult<double> computeImplementation(
    Declaration node,
    Iterable<ScopedClassDeclaration> classDeclarations,
    Iterable<ScopedFunctionDeclaration> functionDeclarations,
    InternalResolvedUnitResult source,
  ) {
    final visitor = HalsteadVolumeAstVisitor();
    node.visitChildren(visitor);

    final lth = visitor.operators + visitor.operands;

    final voc = visitor.uniqueOperators + visitor.uniqueOperands;

    final vol = lth * _log2(voc);

    return MetricComputationResult<double>(value: vol);
  }

  double _log2(int a) => log(max(1, a)) / ln2;
}
