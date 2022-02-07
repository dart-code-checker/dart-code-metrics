part of 'avoid_dynamic_rule.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final _nodes = <AstNode>[];

  Iterable<AstNode> get nodes => _nodes;

  @override
  void visitSimpleIdentifier(SimpleIdentifier node) {
    final parent = node.parent;
    if (parent is NamedType && (parent.type?.isDynamic ?? false)) {
      final grandParent = node.parent?.parent;
      if (grandParent != null) {
        final grandGrandParent = grandParent.parent;
        if (!(grandGrandParent is NamedType &&
            (grandGrandParent.type?.isDartCoreMap ?? false))) {
          _nodes.add(grandParent);
        }
      }
    }
  }
}
