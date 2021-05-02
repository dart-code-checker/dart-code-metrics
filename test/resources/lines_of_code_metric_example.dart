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

class LinesOfCodeMetric extends FunctionMetric<int> {
  @override
  String commentMessage(String nodeType, int value, int threshold) => '';

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
}
