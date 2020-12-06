@TestOn('vm')
import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:dart_code_metrics/src/metrics/nesting_level/nesting_level_visitor.dart';
import 'package:test/test.dart';

const examplePath = 'test/metrics/nesting_level/examples/example.dart';

class ScopeAstVisitor extends RecursiveAstVisitor<void> {
  List<Declaration> functions = <Declaration>[];

  @override
  void visitConstructorDeclaration(ConstructorDeclaration node) {
    if (node.body is! EmptyFunctionBody) {
      functions.add(node);
    }
    super.visitConstructorDeclaration(node);
  }

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    if (node.body is! EmptyFunctionBody) {
      functions.add(node);
    }
    super.visitMethodDeclaration(node);
  }

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    functions.add(node);
    super.visitFunctionDeclaration(node);
  }
}

Future<void> main() async {
  final parseResult = await resolveFile(path: File(examplePath).absolute.path);

  group('NestingLevelVisitor collect information about nesting levels', () {
    final visitor = ScopeAstVisitor();
    parseResult.unit.visitChildren(visitor);

    test('in simple function', () {
      final declaration = visitor.functions.first;

      final nestingLevelVisitor =
          NestingLevelVisitor(declaration, parseResult.lineInfo);
      declaration.visitChildren(nestingLevelVisitor);

      expect(
        nestingLevelVisitor.nestingLines,
        equals([
          [1],
          [2, 1],
          [4, 1],
          [6, 1],
          [7, 6, 1],
        ]),
      );
    });

    test('in constructor', () {
      final declaration = visitor.functions[1];

      final nestingLevelVisitor =
          NestingLevelVisitor(declaration, parseResult.lineInfo);
      declaration.visitChildren(nestingLevelVisitor);

      expect(
        nestingLevelVisitor.nestingLines,
        equals([
          [23],
          [25],
        ]),
      );
    });

    test('in class method', () {
      final declaration = visitor.functions.last;

      final nestingLevelVisitor =
          NestingLevelVisitor(declaration, parseResult.lineInfo);
      declaration.visitChildren(nestingLevelVisitor);

      expect(
        nestingLevelVisitor.nestingLines,
        equals([
          [30],
          [31, 30],
          [33, 30],
        ]),
      );
    });
  });
}
