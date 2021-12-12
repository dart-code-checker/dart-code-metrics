import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/metrics_list/maximum_nesting_level/nesting_level_visitor.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/scope_visitor.dart';
import 'package:test/test.dart';

import '../../../../../helpers/file_resolver.dart';

const _examplePath =
    './test/resources/maximum_nesting_level_metric_example.dart';

Future<void> main() async {
  final result = await FileResolver.resolve(_examplePath);

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
