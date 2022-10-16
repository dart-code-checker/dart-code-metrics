part of 'avoid_cascade_after_if_null_rule.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final _expressions = <Expression>[];

  Iterable<Expression> get expressions => _expressions;

  @override
  void visitBinaryExpression(BinaryExpression node) {
    super.visitBinaryExpression(node);

    if (node.operator.type != TokenType.QUESTION_QUESTION) {
      return;
    }

    final parent = node.parent;
    if (parent is CascadeExpression) {
      _expressions.add(parent);
    }
  }
}
