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
              path: p.normalize(p.absolute(
                  './test/scope_ast_visitor_test/sample_abstract_class.dart')),
              featureSet: FeatureSet.fromEnableFlags([]))
          .unit
          .visitChildren(visitor);

      expect(visitor.declarations, isEmpty);
    });
    test('mixin', () {
      final visitor = ScopeAstVisitor();
      parseFile(
          path: p.normalize(
              p.absolute('./test/scope_ast_visitor_test/sample_mixin.dart')),
          featureSet:
              FeatureSet.fromEnableFlags([])).unit.visitChildren(visitor);

      expect(visitor.declarations.length, equals(1));
      expect(visitor.declarations.first.declaration, isNotNull);
      expect(visitor.declarations.first.declarationIdentifier, isNotNull);
    });

    test('class with factory constructors', () {
      final visitor = ScopeAstVisitor();
      parseFile(
          path: p.normalize(p.absolute(
              './test/scope_ast_visitor_test/class_with_factory_constructors.dart')),
          featureSet:
              FeatureSet.fromEnableFlags([])).unit.visitChildren(visitor);

      expect(visitor.declarations.length, equals(2));
      expect(visitor.declarations.first.declaration,
          TypeMatcher<ConstructorDeclaration>());
      expect(
          (visitor.declarations.first.declaration as ConstructorDeclaration)
              .name
              .toString(),
          '_create');
      expect(visitor.declarations.last.declaration,
          TypeMatcher<ConstructorDeclaration>());
      expect(
          (visitor.declarations.last.declaration as ConstructorDeclaration)
              .name
              .toString(),
          'createInstance');
    });
  });
}
