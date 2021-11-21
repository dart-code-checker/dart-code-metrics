part of 'avoid_throw_in_catch_block_rule.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final _throwExpression = <ThrowExpression>[];

  Iterable<ThrowExpression> get throwExpression => _throwExpression;

  @override
  void visitCatchClause(CatchClause node) {
    super.visitCatchClause(node);

    final visitor = _CatchClauseVisitor();
    node.visitChildren(visitor);

    _throwExpression.addAll(visitor.throwExpression);
  }
}

class _CatchClauseVisitor extends RecursiveAstVisitor<void> {
  final _throwExpression = <ThrowExpression>[];

  Iterable<ThrowExpression> get throwExpression => _throwExpression;

  @override
  void visitThrowExpression(ThrowExpression node) {
    super.visitThrowExpression(node);

    _throwExpression.add(node);
  }
}
