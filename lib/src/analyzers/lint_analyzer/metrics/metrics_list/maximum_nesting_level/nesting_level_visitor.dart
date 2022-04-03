// ignore_for_file: public_member_api_docs

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

/// The AST visitor that will find deepest nested nodes chain of visit nodes in an AST structure.
class NestingLevelVisitor extends RecursiveAstVisitor<void> {
  final AstNode _functionNode;
  var _deepestNestedNodesChain = <AstNode>[];

  /// Returns the deepest nested nodes chain.
  Iterable<AstNode> get deepestNestedNodesChain => _deepestNestedNodesChain;

  /// Initialize a newly created [NestingLevelVisitor] with given [_functionNode].
  NestingLevelVisitor(this._functionNode);

  @override
  void visitBlock(Block node) {
    final nestedNodesChain = <AstNode>[];

    AstNode? astNode = node;
    do {
      final parent = astNode?.parent;
      final grandParent = parent?.parent;
      if (astNode is Block &&
          (parent is! BlockFunctionBody ||
              grandParent is ConstructorDeclaration ||
              grandParent is FunctionExpression ||
              grandParent is MethodDeclaration)) {
        nestedNodesChain.add(astNode);
      }

      astNode = parent;
    } while (astNode?.parent != _functionNode);

    if (nestedNodesChain.length > _deepestNestedNodesChain.length) {
      _deepestNestedNodesChain = nestedNodesChain;
    }

    super.visitBlock(node);
  }
}
