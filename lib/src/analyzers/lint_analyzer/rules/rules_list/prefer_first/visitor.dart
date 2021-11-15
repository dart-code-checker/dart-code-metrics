part of 'prefer_first_rule.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final _expressions = <Expression>[];

  Iterable<Expression> get expressions => _expressions;

  @override
  void visitMethodInvocation(MethodInvocation node) {
    super.visitMethodInvocation(node);

    if (isIterableOrSubclass(node.realTarget?.staticType) &&
        node.methodName.name == 'elementAt') {
      final arg = node.argumentList.arguments.first;

      if (arg is IntegerLiteral && arg.value == 0) {
        _expressions.add(node);
      }
    }
  }

  @override
  void visitIndexExpression(IndexExpression node) {
    super.visitIndexExpression(node);

    if (isListOrSubclass(node.realTarget.staticType)) {
      final index = node.index;

      if (index is IntegerLiteral && index.value == 0) {
        _expressions.add(node);
      }
    }
  }
}
