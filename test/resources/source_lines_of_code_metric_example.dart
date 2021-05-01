import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:dart_code_metrics/src/metrics/function_metric.dart';
import 'package:dart_code_metrics/src/metrics/metric_computation_result.dart';
import 'package:dart_code_metrics/src/models/scoped_class_declaration.dart';
import 'package:dart_code_metrics/src/models/scoped_function_declaration.dart';

void simpleFunction() {
  // simple comment

  print('simple report');
}

class SourceLinesOfCodeMetric extends FunctionMetric<int> {
  @override
  MetricComputationResult<int> computeImplementation(
    Declaration node,
    Iterable<ScopedClassDeclaration> classDeclarations,
    Iterable<ScopedFunctionDeclaration> functionDeclarations,
    InternalResolvedUnitResult source,
  ) {
    final visitor = SourceCodeVisitor(source.lineInfo);
    node.visitChildren(visitor);

    return MetricComputationResult(
      value: visitor.linesWithCode.length,
      context: _context(node, visitor.linesWithCode, source),
    );
  }

  @override
  String? recommendationMessage(String nodeType, int value, int threshold) =>
      (value > threshold)
          ? 'Consider breaking this $nodeType up into smaller parts.'
          : null;
}
