@TestOn('vm')
import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:code_checker/checker.dart';
import 'package:dart_code_metrics/src/scope_ast_visitor.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  group('analyze file with', () {
    test('abstract class', () {
      final visitor = ScopeAstVisitor();
      parseFile(
        path: p.normalize(p.absolute('./test/resources/abstract_class.dart')),
        featureSet: FeatureSet.fromEnableFlags([]),
      ).unit.visitChildren(visitor);

      final component = visitor.components.single;
      expect(component.declaration, const TypeMatcher<ClassDeclaration>());
      expect(
        (component.declaration as ClassDeclaration).name.name,
        equals('Foo'),
      );

      expect(visitor.functions, isEmpty);
    });

    test('function', () {
      final visitor = ScopeAstVisitor();
      parseFile(
        path: p.normalize(p.absolute('./test/resources/function.dart')),
        featureSet: FeatureSet.fromEnableFlags([]),
      ).unit.visitChildren(visitor);

      expect(visitor.components, isEmpty);

      final function = visitor.functions.single;
      expect(function.type, equals(FunctionType.function));
      expect(function.declaration, const TypeMatcher<FunctionDeclaration>());
      expect(
        (function.declaration as FunctionDeclaration).name.name,
        equals('say'),
      );
    });

    test('class with factory constructors', () {
      final visitor = ScopeAstVisitor();
      parseFile(
        path: p.normalize(p
            .absolute('./test/resources/class_with_factory_constructors.dart')),
        featureSet: FeatureSet.fromEnableFlags([]),
      ).unit.visitChildren(visitor);

      final component = visitor.components.single;
      expect(component.declaration, const TypeMatcher<ClassDeclaration>());
      expect(
        (component.declaration as ClassDeclaration).name.name,
        equals('SampleClass'),
      );

      final functions = visitor.functions;
      expect(functions.length, equals(2));
      expect(functions.first.type, equals(FunctionType.constructor));
      expect(
        functions.first.declaration,
        const TypeMatcher<ConstructorDeclaration>(),
      );
      expect(
        (functions.first.declaration as ConstructorDeclaration).name.name,
        equals('_create'),
      );
      expect(
        functions.first.enclosingDeclaration.declaration,
        const TypeMatcher<ClassDeclaration>(),
      );
      expect(
        (functions.first.enclosingDeclaration.declaration as ClassDeclaration)
            .name
            .name,
        equals('SampleClass'),
      );

      expect(functions.last.type, equals(FunctionType.constructor));
      expect(
        functions.last.declaration,
        const TypeMatcher<ConstructorDeclaration>(),
      );
      expect(
        (functions.last.declaration as ConstructorDeclaration).name.name,
        equals('createInstance'),
      );
      expect(
        functions.last.enclosingDeclaration.declaration,
        const TypeMatcher<ClassDeclaration>(),
      );
      expect(
        (functions.last.enclosingDeclaration.declaration as ClassDeclaration)
            .name
            .name,
        equals('SampleClass'),
      );
    });

    test('mixin', () {
      final visitor = ScopeAstVisitor();
      parseFile(
        path: p.normalize(p.absolute('./test/resources/mixin.dart')),
        featureSet: FeatureSet.fromEnableFlags([]),
      ).unit.visitChildren(visitor);

      final component = visitor.components.single;
      expect(component.declaration, const TypeMatcher<MixinDeclaration>());
      expect(
        (component.declaration as MixinDeclaration).name.name,
        equals('ValuesMapping'),
      );

      final function = visitor.functions.single;
      expect(function.type, equals(FunctionType.method));
      expect(function.declaration, const TypeMatcher<MethodDeclaration>());
      expect(
        (function.declaration as MethodDeclaration).name.name,
        equals('findValueByKey'),
      );
      expect(
        function.enclosingDeclaration.declaration,
        const TypeMatcher<MixinDeclaration>(),
      );
      expect(
        (function.enclosingDeclaration.declaration as MixinDeclaration)
            .name
            .name,
        equals('ValuesMapping'),
      );
    });
  });
}
