@TestOn('vm')
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:dart_code_metrics/src/metrics/function_metric.dart';
import 'package:dart_code_metrics/src/metrics/metric_computation_result.dart';
import 'package:dart_code_metrics/src/models/function_type.dart';
import 'package:dart_code_metrics/src/models/scoped_class_declaration.dart';
import 'package:dart_code_metrics/src/models/scoped_function_declaration.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class CompilationUnitMemberMock extends Mock implements CompilationUnitMember {}

class DeclarationMock extends Mock implements Declaration {}

class FunctionMetricTest extends FunctionMetric<int> {
  @override
  MetricComputationResult<int> computeImplementation(
    Declaration node,
    Iterable<ScopedClassDeclaration> classDeclarations,
    Iterable<ScopedFunctionDeclaration> functionDeclarations,
    ResolvedUnitResult source,
  ) =>
      null;

  @override
  String commentMessage(String type, int value, int threshold) => null;
}

void main() {
  test('FunctionMetric nodeType returns type of passed node', () {
    final firstNode = CompilationUnitMemberMock();
    final secondNode = CompilationUnitMemberMock();
    final thirdNode = CompilationUnitMemberMock();
    final fourthNode = CompilationUnitMemberMock();
    final fifthNode = CompilationUnitMemberMock();
    final sixthNode = CompilationUnitMemberMock();

    final functions = [
      ScopedFunctionDeclaration(FunctionType.constructor, firstNode, null),
      ScopedFunctionDeclaration(FunctionType.method, secondNode, null),
      ScopedFunctionDeclaration(FunctionType.function, thirdNode, null),
      ScopedFunctionDeclaration(FunctionType.getter, fourthNode, null),
      ScopedFunctionDeclaration(FunctionType.setter, fifthNode, null),
    ];

    expect(
      FunctionMetricTest().nodeType(firstNode, [], functions),
      equals('constructor'),
    );
    expect(
      FunctionMetricTest().nodeType(secondNode, [], functions),
      equals('method'),
    );
    expect(
      FunctionMetricTest().nodeType(thirdNode, [], functions),
      equals('function'),
    );
    expect(
      FunctionMetricTest().nodeType(fourthNode, [], functions),
      equals('getter'),
    );
    expect(
      FunctionMetricTest().nodeType(fifthNode, [], functions),
      equals('setter'),
    );
    expect(FunctionMetricTest().nodeType(sixthNode, [], functions), isNull);
  });
}
