part of 'avoid_non_null_assertion.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final _expressions = <Expression>[];

  Iterable<Expression> get expressions => _expressions;

  @override
  void visitPostfixExpression(PostfixExpression node) {
    super.visitPostfixExpression(node);

    if (node.operator.type == TokenType.BANG &&
        !_isMapIndexOperator(node.operand)) {
      _expressions.add(node);
    }
  }

  bool _isMapIndexOperator(Expression operand) {
    if (operand is IndexExpression) {
      final type = operand.target?.staticType;

      return type != null && type.isDartCoreMap;
    }

    return false;
  }
}
