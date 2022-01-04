part of 'avoid_global_state_rule.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final _declarations = <AstNode>[];

  Iterable<AstNode> get declarations => _declarations;

  @override
  void visitVariableDeclaration(VariableDeclaration node) {
    super.visitVariableDeclaration(node);

    if (!node.isFinal &&
        !node.isConst &&
        node.declaredElement?.enclosingElement is CompilationUnitElement) {
      _declarations.add(node);
    }
  }
}
