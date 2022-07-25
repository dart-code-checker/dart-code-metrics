part of 'avoid_global_state_rule.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final _declarations = <AstNode>[];

  Iterable<AstNode> get declarations => _declarations;

  @override
  void visitVariableDeclaration(VariableDeclaration node) {
    super.visitVariableDeclaration(node);

    // ignore: deprecated_member_use
    if (node.declaredElement?.enclosingElement is CompilationUnitElement) {
      if (_isNodeValid(node)) {
        _declarations.add(node);
      }
    } else if ((node.declaredElement?.isStatic ?? false) &&
        _isNodeValid(node)) {
      _declarations.add(node);
    }
  }

  bool _isNodeValid(VariableDeclaration node) =>
      !node.isFinal &&
      !node.isConst &&
      !(node.declaredElement?.isPrivate ?? false);
}
