part of 'prefer_const_border_radius.dart';

class _Visitor extends RecursiveAstVisitor<dynamic> {
  final _borderRadiusNodes = <AstNode>[];

  Iterable<AstNode> get borderRadiusNodes => _borderRadiusNodes;

  @override
  void visitTypeName(TypeName node) {
    super.visitTypeName(node);

    final borderRadiusNode = _getBorderRadiusElementDeclaration(node);
    if (borderRadiusNode != null) {
      _borderRadiusNodes.add(borderRadiusNode);
    }
  }

  AstNode? _getBorderRadiusElementDeclaration(TypeName element) {
    final isBorderRadius =
        element.parent?.beginToken.lexeme == 'BorderRadius' &&
            element.parent?.endToken.lexeme == 'circular';

    return isBorderRadius ? element.parent!.parent : null;
  }
}
