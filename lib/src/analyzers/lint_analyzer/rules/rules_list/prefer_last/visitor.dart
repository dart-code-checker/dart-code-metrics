part of 'prefer_last_rule.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final _expressions = <Expression>[];

  Iterable<Expression> get expressions => _expressions;

  @override
  void visitMethodInvocation(MethodInvocation node) {
    super.visitMethodInvocation(node);

    final target = node.realTarget;

    if (isIterableOrSubclass(target?.staticType) &&
        node.methodName.name == 'elementAt') {
      final arg = node.argumentList.arguments.first;

      if (arg is BinaryExpression &&
          _isLastElementAccess(arg, target.toString())) {
        _expressions.add(node);
      }
    }
  }

  @override
  void visitIndexExpression(IndexExpression node) {
    super.visitIndexExpression(node);

    final target = node.realTarget;

    if (isListOrSubclass(target.staticType)) {
      final index = node.index;

      if (index is BinaryExpression &&
          _isLastElementAccess(index, target.toString())) {
        _expressions.add(node);
      }
    }
  }

  bool _isLastElementAccess(BinaryExpression expression, String targetName) {
    final left = expression.leftOperand;
    final right = expression.rightOperand;

    return left is PrefixedIdentifier &&
        right is IntegerLiteral &&
        left.name == '$targetName.length' &&
        expression.operator.type == TokenType.MINUS &&
        right.value == 1;
  }
}
