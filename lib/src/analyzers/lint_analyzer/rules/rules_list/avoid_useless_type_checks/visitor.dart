part of 'avoid_useless_type_checks.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final _expressions = <Expression>[];

  _Visitor();

  Iterable<Expression> get expressions => _expressions;

  @override
  void visitAsExpression(AsExpression node) {
    if (node.expression.staticType.toString() == node.type.toString()) {
      _expressions.add(node);
    }
  }

  @override
  void visitIsExpression(IsExpression node) {
    if (node.expression.staticType.toString() == node.type.toString()) {
      _expressions.add(node);
    }
  }
}
