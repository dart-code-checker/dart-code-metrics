part of 'avoid_shrink_wrap_in_lists_rule.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final _expressions = <Expression>[];

  Iterable<Expression> get expressions => _expressions;

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    super.visitInstanceCreationExpression(node);

    if (isListViewWidget(node.staticType) &&
        _hasShrinkWrap(node) &&
        _hasParentList(node)) {
      _expressions.add(node);
    }
  }

  bool _hasShrinkWrap(InstanceCreationExpression node) =>
      node.argumentList.arguments.firstWhereOrNull(
        (arg) => arg is NamedExpression && arg.name.label.name == 'shrinkWrap',
      ) !=
      null;

  bool _hasParentList(InstanceCreationExpression node) =>
      node.thisOrAncestorMatching((parent) =>
          parent != node &&
          parent is InstanceCreationExpression &&
          (isListViewWidget(parent.staticType) ||
              isColumnWidget(parent.staticType) ||
              isRowWidget(parent.staticType))) !=
      null;
}
