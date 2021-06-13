part of 'avoid_wrapping_in_padding.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final _expressions = <Expression>[];

  Iterable<Expression> get expressions => _expressions;

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    super.visitInstanceCreationExpression(node);

    if (isPaddingWidget(node.staticType) && _hasChildWithPadding(node)) {
      _expressions.add(node);
    }
  }

  bool _hasChildWithPadding(InstanceCreationExpression node) {
    final child = node.argumentList.arguments.firstWhereOrNull(
      (arg) => arg is NamedExpression && arg.name.label.name == 'child',
    );

    if (child != null && child is NamedExpression) {
      final expression = child.expression;
      if (expression is InstanceCreationExpression) {
        final element = expression.staticType?.element;
        if (element is ClassElement) {
          return element.fields
                  .firstWhereOrNull((filed) => filed.name == 'padding') !=
              null;
        }
      }
    }

    return false;
  }
}
