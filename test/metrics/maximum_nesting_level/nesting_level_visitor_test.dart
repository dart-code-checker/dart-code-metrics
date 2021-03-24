@TestOn('vm')
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:dart_code_metrics/src/metrics/maximum_nesting_level/nesting_level_visitor.dart';
import 'package:dart_code_metrics/src/scope_visitor.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

const examplePath =
    './test/resources/maximum_nesting_level_metric_example.dart';

Future<void> main() async {
  final result = await resolveFile(path: p.normalize(p.absolute(examplePath)));

  group('NestingLevelVisitor collect information about nesting levels', () {
    final scopeVisitor = ScopeVisitor();
    result.unit.visitChildren(scopeVisitor);

    test('in simple function', () {
      final declaration = scopeVisitor.functions.first.declaration;

      final nestingLevelVisitor = NestingLevelVisitor(declaration);
      declaration.visitChildren(nestingLevelVisitor);

      expect(
        nestingLevelVisitor.deepestNestedNodesChain.map((node) => node.offset),
        equals([320, 298, 194]),
      );
    });

    test('in constructor', () {
      final declaration = scopeVisitor.functions.toList()[1].declaration;

      final nestingLevelVisitor = NestingLevelVisitor(declaration);
      declaration.visitChildren(nestingLevelVisitor);

      expect(
        nestingLevelVisitor.deepestNestedNodesChain.map((node) => node.offset),
        equals([514, 464]),
      );
    });

    test('in class method', () {
      final declaration = scopeVisitor.functions.last.declaration;

      final nestingLevelVisitor = NestingLevelVisitor(declaration);
      declaration.visitChildren(nestingLevelVisitor);

      expect(
        nestingLevelVisitor.deepestNestedNodesChain.map((node) => node.offset),
        equals([1474, 1261, 1180]),
      );
    });
  });
}
