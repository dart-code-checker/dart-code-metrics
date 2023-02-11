part of 'no_boolean_literal_compare_rule.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  static const _scannedTokenTypes = {TokenType.EQ_EQ, TokenType.BANG_EQ};

  final _expressions = <BinaryExpression>[];

  Iterable<BinaryExpression> get expressions => _expressions;

  @override
  void visitBinaryExpression(BinaryExpression node) {
    super.visitBinaryExpression(node);

    if (!_scannedTokenTypes.contains(node.operator.type)) {
      return;
    }

    if ((node.leftOperand is BooleanLiteral &&
            _isTypeBoolean(node.rightOperand.staticType)) ||
        (_isTypeBoolean(node.leftOperand.staticType) &&
            node.rightOperand is BooleanLiteral)) {
      _expressions.add(node);
    }
  }

  bool _isTypeBoolean(DartType? type) =>
      type != null && type.isDartCoreBool && !isNullableType(type);
}
