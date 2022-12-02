part of 'prefer_using_list_view_rule.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final _expressions = <Expression>[];

  Iterable<Expression> get expressions => _expressions;

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    super.visitInstanceCreationExpression(node);

    if (isSingleChildScrollViewWidget(node.staticType) &&
        _hasColumnChild(node)) {
      _expressions.add(node);
    }
  }

  bool _hasColumnChild(InstanceCreationExpression node) {
    final child = node.argumentList.arguments.firstWhereOrNull(
      (arg) => arg is NamedExpression && arg.name.label.name == 'child',
    );

    if (child != null && child is NamedExpression) {
      final expression = child.expression;

      if (expression is InstanceCreationExpression &&
          isColumnWidget(expression.staticType)) {
        final notChildren = expression.argumentList.arguments.firstWhereOrNull(
          (arg) => arg is NamedExpression && arg.name.label.name != 'children',
        );

        return notChildren == null;
      }
    }

    return false;
  }
}
