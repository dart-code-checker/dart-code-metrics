@TestOn('vm')
import 'package:analyzer/dart/ast/ast.dart';
import 'package:dart_code_metrics/src/metrics_analyzer_utils.dart';
import 'package:dart_code_metrics/src/models/scoped_declaration.dart';
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
  group('getArgumentsCount return arguments count of', () {
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

      final declaration = ScopedDeclaration(functionDeclarationMock, null);

      expect(getArgumentsCount(declaration), 1);
    });

    test('class method', () {
      final methodDeclarationMock = MethodDeclarationMock();

      final declaration = ScopedDeclaration(methodDeclarationMock, null);

      expect(getArgumentsCount(declaration), 0);

      when(methodDeclarationMock.parameters)
          .thenReturn(formalParameterListMock);
      when(nodeListMock.length).thenReturn(2);

      expect(getArgumentsCount(declaration), 2);
    });

    test('class constructor', () {
      final declaration = ScopedDeclaration(ConstructorDeclarationMock(), null);

      expect(getArgumentsCount(declaration), 0);
    });
  });
}
