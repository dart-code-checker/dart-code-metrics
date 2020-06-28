@TestOn('vm')
import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:dart_code_metrics/src/metrics_analyzer_utils.dart';
import 'package:dart_code_metrics/src/models/scoped_function_declaration.dart';
import 'package:dart_code_metrics/src/scope_ast_visitor.dart';
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

      final declaration =
          ScopedFunctionDeclaration(functionDeclarationMock, null);

      expect(getArgumentsCount(declaration), equals(1));
    });

    test('class method', () {
      final methodDeclarationMock = MethodDeclarationMock();

      final declaration =
          ScopedFunctionDeclaration(methodDeclarationMock, null);

      expect(getArgumentsCount(declaration), 0);

      when(methodDeclarationMock.parameters)
          .thenReturn(formalParameterListMock);
      when(nodeListMock.length).thenReturn(2);

      expect(getArgumentsCount(declaration), equals(2));
    });

    test('class constructor', () {
      final declaration =
          ScopedFunctionDeclaration(ConstructorDeclarationMock(), null);

      expect(getArgumentsCount(declaration), isZero);
    });
  });

  test('getFunctionHumanReadableName returns human readable name', () {
    expect(getFunctionHumanReadableName(null), isNull);

    <String, List<String>>{
      './test/resources/abstract_class.dart': [],
      './test/resources/class_with_factory_constructors.dart': [
        'SampleClass._create',
        'SampleClass.createInstance',
      ],
      './test/resources/mixed.dart': [
        'pi',
        'Bar.twoPi',
        'Rectangle.right',
        'Rectangle.right',
        'Rectangle.bottom',
        'Rectangle.bottom',
      ],
      './test/resources/mixin.dart': ['ValuesMapping.findValueByKey'],
    }.forEach((fileName, declatationNames) {
      final visitor = ScopeAstVisitor();

      parseFile(
              path: p.normalize(p.absolute(fileName)),
              featureSet: FeatureSet.fromEnableFlags([]))
          .unit
          .visitChildren(visitor);

      expect(visitor.functions.map(getFunctionHumanReadableName),
          equals(declatationNames));
    });
  });
}
