part of 'binary_expression_operand_order_rule.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final _binaryExpressions = <BinaryExpression>[];

  Iterable<BinaryExpression> get binaryExpressions => _binaryExpressions;

  @override
  void visitBinaryExpression(BinaryExpression e) {
    if (_supportedLeftOperand(e.leftOperand) &&
        _supportedRightOperand(e.rightOperand) &&
        _supportedOperator(e.operator)) {
      _binaryExpressions.add(e);
    }
    super.visitBinaryExpression(e);
  }

  bool _supportedLeftOperand(Expression operand) =>
      operand is IntegerLiteral || operand is DoubleLiteral;

  bool _supportedRightOperand(Expression operand) => operand is Identifier;

  bool _supportedOperator(Token operator) =>
      operator.type == TokenType.PLUS ||
      operator.type == TokenType.STAR ||
      operator.type == TokenType.AMPERSAND ||
      operator.type == TokenType.BAR ||
      operator.type == TokenType.CARET;
}
