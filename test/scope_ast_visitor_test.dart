@TestOn('vm')
import 'package:analyzer/analyzer.dart';
import 'package:metrics/src/scope_ast_visitor.dart';
import 'package:test/test.dart';

void main() {
  group('analyze file with ', () {
    test('abstract class', () {
      final visitor = ScopeAstVisitor();
      parseDartFile('./test/scope_ast_visitor_test/sample_abstract_class.dart').visitChildren(visitor);

      expect(visitor.declarations, isEmpty);
    });
    test('mixin', () {
      final visitor = ScopeAstVisitor();
      parseDartFile('./test/scope_ast_visitor_test/sample_mixin.dart').visitChildren(visitor);

      expect(visitor.declarations.length, equals(1));
      expect(visitor.declarations.first.declaration, isNotNull);
      expect(visitor.declarations.first.enclosingClass, isNotNull);
    });
  });
}
