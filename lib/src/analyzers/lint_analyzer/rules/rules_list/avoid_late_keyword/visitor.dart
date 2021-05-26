part of 'avoid_late_keyword.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final _declarations = <AstNode>[];

  Iterable<AstNode> get declarations => _declarations;

  @override
  void visitVariableDeclaration(VariableDeclaration node) {
    super.visitVariableDeclaration(node);

    if (node.isLate && node.parent != null) {
      final parent = node.parent;

      _declarations.add(parent ?? node);
    }
  }
}
