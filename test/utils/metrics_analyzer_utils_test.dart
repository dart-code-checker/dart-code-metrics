@TestOn('vm')
import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:code_checker/checker.dart';
import 'package:dart_code_metrics/src/utils/metrics_analyzer_utils.dart';
import 'package:mockito/mockito.dart';
import 'package:path/path.dart' as p;
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

  test('getFunctionHumanReadableName returns human readable name', () {
    expect(getFunctionHumanReadableName(null), isNull);

    <String, Iterable<String>>{
      './test/resources/abstract_class.dart': [],
      './test/resources/class_with_factory_constructors.dart': [
        'SampleClass._create',
        'SampleClass.createInstance',
      ],
      './test/resources/extension.dart': [
        'SimpleObjectExtensions.as',
      ],
      './test/resources/function.dart': [
        'say',
      ],
      './test/resources/mixed.dart': [
        'pi',
        'Bar.twoPi',
        'Rectangle.Rectangle',
        'Rectangle.right',
        'Rectangle.right',
        'Rectangle.bottom',
        'Rectangle.bottom',
      ],
      './test/resources/mixin.dart': [
        'ValuesMapping.findValueByKey',
      ],
    }.forEach((fileName, declarationNames) {
      final visitor = ScopeVisitor();

      parseFile(
        path: p.normalize(p.absolute(fileName)),
        featureSet: FeatureSet.fromEnableFlags([]),
      ).unit.visitChildren(visitor);

      expect(
        visitor.functions.where((function) {
          final declaration = function.declaration;
          if (declaration is ConstructorDeclaration &&
              declaration.body is EmptyFunctionBody) {
            return false;
          } else if (declaration is MethodDeclaration &&
              declaration.body is EmptyFunctionBody) {
            return false;
          }

          return true;
        }).map(getFunctionHumanReadableName),
        equals(declarationNames),
      );
    });
  });
}
