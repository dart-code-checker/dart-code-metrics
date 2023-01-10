part of 'avoid_late_keyword_rule.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final bool allowInitialized;

  final _declarations = <AstNode>[];

  Iterable<AstNode> get declarations => _declarations;

  // ignore: avoid_positional_boolean_parameters
  _Visitor(this.allowInitialized);

  @override
  void visitVariableDeclaration(VariableDeclaration node) {
    super.visitVariableDeclaration(node);

    if (node.isLate && node.parent != null) {
      final parent = node.parent;

      if (!(allowInitialized && node.initializer != null)) {
        _declarations.add(parent ?? node);
      }
    }
  }
}
