import 'package:analyzer/dart/ast/ast.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/models/function_metric.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/models/metric_computation_result.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/models/metric_value.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/internal_resolved_unit_result.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/scoped_class_declaration.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/scoped_function_declaration.dart';

void simpleFunction() {
  // simple comment

  print('simple report');
}

void simpleFunctionWithArguments(
  int a, {
  String b,
}) {}

set simpleSetter(num value) {}

String get simpleGetter => '';

class NumberOfParametersMetric extends FunctionMetric<int> {
  NumberOfParametersMetric();

  @override
  String commentMessage(String nodeType, int value, int? threshold) => '';

  @override
  MetricComputationResult<int> computeImplementation(
    Declaration node,
    Iterable<ScopedClassDeclaration> classDeclarations,
    Iterable<ScopedFunctionDeclaration> functionDeclarations,
    InternalResolvedUnitResult source,
    Iterable<MetricValue> otherMetricsValues,
  ) {
    int? parametersCount;
    if (node is FunctionDeclaration) {
      parametersCount = node.functionExpression.parameters?.parameters.length;
    } else if (node is MethodDeclaration) {
      parametersCount = node.parameters?.parameters.length;
    }

    return MetricComputationResult(value: parametersCount ?? 0);
  }
}

class Foo {
  final String a;
  final String b;
  final String c;
  final String d;
  final String e;

  const Foo({
    required this.a,
    required this.b,
    required this.c,
    required this.d,
    required this.e,
  });

  Foo copyWith({String a, String b, String c, String d, String e}) => Foo(
        a: a ?? this.a,
        b: b ?? this.b,
        c: c ?? this.c,
        d: d ?? this.d,
        e: e ?? this.e,
      );
}
