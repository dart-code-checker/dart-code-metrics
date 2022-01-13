part of 'avoid_global_state_rule.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final _declarations = <AstNode>[];

  Iterable<AstNode> get declarations => _declarations;

  @override
  void visitVariableDeclaration(VariableDeclaration node) {
    super.visitVariableDeclaration(node);

    if (node.declaredElement?.enclosingElement is CompilationUnitElement) {
      if (!node.isFinal && !node.isConst) {
        _declarations.add(node);
      }
    } else {
      if ((node.declaredElement?.isStatic ?? false) &&
          !node.isFinal &&
          !node.isConst) {
        _declarations.add(node);
      }
    }
  }
}
