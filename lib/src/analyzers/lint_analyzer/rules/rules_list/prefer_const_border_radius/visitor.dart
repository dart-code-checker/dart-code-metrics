part of 'prefer_const_border_radius.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final _nodes = <InstanceCreationExpression>[];

  Iterable<InstanceCreationExpression> get nodes => _nodes;

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    super.visitInstanceCreationExpression(node);

    if (node.constructorName.beginToken.lexeme == 'BorderRadius' &&
        node.constructorName.endToken.lexeme == 'circular') {
      _nodes.add(node);
    }
  }
}
