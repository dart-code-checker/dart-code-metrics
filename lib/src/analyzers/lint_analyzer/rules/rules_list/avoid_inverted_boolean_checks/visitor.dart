part of 'avoid_inverted_boolean_checks_rule.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final _expressions = <PrefixExpression>[];

  Iterable<PrefixExpression> get expressions => _expressions;

  _Visitor();

  @override
  void visitPrefixExpression(PrefixExpression node) {
    if (node.operator.lexeme == '!' &&
        node.operand is ParenthesizedExpression) {
      _expressions.add(node);
    }

    super.visitPrefixExpression(node);
  }
}
