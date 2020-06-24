@TestOn('vm')
import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:dart_code_metrics/src/scope_ast_visitor.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  group('analyze file with', () {
    test('abstract class', () {
      final visitor = ScopeAstVisitor();
      parseFile(
          path: p.normalize(p.absolute('./test/resources/abstract_class.dart')),
          featureSet:
              FeatureSet.fromEnableFlags([])).unit.visitChildren(visitor);

      expect(visitor.declarations, isEmpty);
    });

    test('function', () {
      final visitor = ScopeAstVisitor();
      parseFile(
              path: p.normalize(p.absolute('./test/resources/function.dart')),
              featureSet: FeatureSet.fromEnableFlags([]))
          .unit
          .visitChildren(visitor);

      final declaration = visitor.declarations.single;
      expect(declaration.declaration, const TypeMatcher<FunctionDeclaration>());
      expect((declaration.declaration as FunctionDeclaration).name.name,
          equals('say'));
    });

    test('class with factory constructors', () {
      final visitor = ScopeAstVisitor();
      parseFile(
              path: p.normalize(p.absolute(
                  './test/resources/class_with_factory_constructors.dart')),
              featureSet: FeatureSet.fromEnableFlags([]))
          .unit
          .visitChildren(visitor);

      final declarations = visitor.declarations;
      expect(declarations.length, equals(2));
      expect(declarations.first.declaration,
          const TypeMatcher<ConstructorDeclaration>());
      expect(
          (declarations.first.declaration as ConstructorDeclaration).name.name,
          equals('_create'));
      expect(declarations.first.enclosingDeclaration,
          const TypeMatcher<ClassDeclaration>());
      expect(
          (declarations.first.enclosingDeclaration as ClassDeclaration)
              .name
              .name,
          equals('SampleClass'));
      expect(declarations.last.declaration,
          const TypeMatcher<ConstructorDeclaration>());
      expect(
          (declarations.last.declaration as ConstructorDeclaration).name.name,
          equals('createInstance'));
      expect(declarations.last.enclosingDeclaration,
          const TypeMatcher<ClassDeclaration>());
      expect(
          (declarations.last.enclosingDeclaration as ClassDeclaration)
              .name
              .name,
          equals('SampleClass'));
    });

    test('mixin', () {
      final visitor = ScopeAstVisitor();
      parseFile(
              path: p.normalize(p.absolute('./test/resources/mixin.dart')),
              featureSet: FeatureSet.fromEnableFlags([]))
          .unit
          .visitChildren(visitor);

      final declaration = visitor.declarations.single;
      expect(declaration.declaration, const TypeMatcher<MethodDeclaration>());
      expect((declaration.declaration as MethodDeclaration).name.name,
          equals('findValueByKey'));
      expect(declaration.enclosingDeclaration,
          const TypeMatcher<MixinDeclaration>());
      expect((declaration.enclosingDeclaration as MixinDeclaration).name.name,
          equals('ValuesMapping'));
    });
  });
}
