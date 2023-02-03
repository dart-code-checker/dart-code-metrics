import 'package:analyzer/dart/ast/ast.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/models/function_metric.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/models/metric_documentation.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/models/metric_value_level.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/function_type.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/scoped_function_declaration.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class CompilationUnitMemberMock extends Mock implements CompilationUnitMember {}

class DocumentationMock extends Mock implements MetricDocumentation {}

class FunctionMetricTest extends FunctionMetric<int> {
  FunctionMetricTest()
      : super(
          id: '0',
          documentation: DocumentationMock(),
          threshold: 0,
          levelComputer: (_, __) => MetricValueLevel.none,
        );

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
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
