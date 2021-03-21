@TestOn('vm')
// ignore_for_file: prefer-trailing-comma
import 'package:analyzer/dart/ast/ast.dart';
import 'package:code_checker/checker.dart';
import 'package:dart_code_metrics/src/obsoleted/utils/metrics_analyzer_utils.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class ConstructorDeclarationMock extends Mock
    implements ConstructorDeclaration {}

class FunctionDeclarationMock extends Mock implements FunctionDeclaration {}

class FunctionExpressionMock extends Mock implements FunctionExpression {}

class FormalParameterListMock extends Mock implements FormalParameterList {}

class NodeListMock<E extends AstNode> extends Mock implements NodeList<E> {}

class MethodDeclarationMock extends Mock implements MethodDeclaration {}

void main() {
  group('getArgumentsCount returns arguments count of', () {
    FormalParameterListMock formalParameterListMock;
    NodeListMock<FormalParameter> nodeListMock;

    setUp(() {
      formalParameterListMock = FormalParameterListMock();
      nodeListMock = NodeListMock<FormalParameter>();

      when(formalParameterListMock.parameters).thenReturn(nodeListMock);
    });

    test('static function', () {
      final functionDeclarationMock = FunctionDeclarationMock();
      final functionExpressionMock = FunctionExpressionMock();

      when(functionDeclarationMock.functionExpression)
          .thenReturn(functionExpressionMock);
      when(functionExpressionMock.parameters)
          .thenReturn(formalParameterListMock);
      when(nodeListMock.length).thenReturn(1);

      final declaration = ScopedFunctionDeclaration(
          FunctionType.function, functionDeclarationMock, null);

      expect(getArgumentsCount(declaration), equals(1));
    });

    test('class method', () {
      final methodDeclarationMock = MethodDeclarationMock();

      final declaration = ScopedFunctionDeclaration(
          FunctionType.function, methodDeclarationMock, null);

      expect(getArgumentsCount(declaration), 0);

      when(methodDeclarationMock.parameters)
          .thenReturn(formalParameterListMock);
      when(nodeListMock.length).thenReturn(2);

      expect(getArgumentsCount(declaration), equals(2));
    });

    test('class constructor', () {
      final declaration = ScopedFunctionDeclaration(
          FunctionType.function, ConstructorDeclarationMock(), null);

      expect(getArgumentsCount(declaration), isZero);
    });
  });
}
