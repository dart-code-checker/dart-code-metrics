part of 'prefer_const_border_radius.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final _nodes = <AstNode>[];

  Iterable<AstNode> get nodes => _nodes;

  @override
  void visitTypeName(TypeName node) {
    super.visitTypeName(node);

    final borderRadiusNode = _getBorderRadiusElementDeclaration(node);
    if (borderRadiusNode != null) {
      _nodes.add(borderRadiusNode);
    }
  }

  AstNode? _getBorderRadiusElementDeclaration(TypeName element) {
    final isBorderRadius =
        element.parent?.beginToken.lexeme == 'BorderRadius' &&
            element.parent?.endToken.lexeme == 'circular';

    return isBorderRadius ? element.parent!.parent : null;
  }
}
