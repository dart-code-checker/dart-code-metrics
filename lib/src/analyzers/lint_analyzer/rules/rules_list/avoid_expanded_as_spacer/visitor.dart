part of 'avoid_expanded_as_spacer_rule.dart';

const _expandedClassName = 'Expanded';
const _containerClassName = 'Container';
const _sizeBoxClassName = 'SizeBox';

class _Visitor extends RecursiveAstVisitor<void> {
  final _expressions = <InstanceCreationExpression>[];

  Iterable<InstanceCreationExpression> get expressions => _expressions;

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression expression) {
    super.visitInstanceCreationExpression(expression);

    final arguments = expression.argumentList.arguments;
    final isExpanded = expression.staticType?.getDisplayString(
          withNullability: true,
        ) ==
        _expandedClassName;

    final hasOneArgument = arguments.length == 1;

    if (isExpanded && hasOneArgument) {
      final expandedChild = arguments.first as NamedExpression;

      final childName = expandedChild.staticType?.getDisplayString(
        withNullability: true,
      );

      final child = expandedChild.expression;
      if (child is InstanceCreationExpression) {
        final hasNoArgument = child.argumentList.arguments.isEmpty;

        if (hasNoArgument &&
            (childName == _containerClassName ||
                childName == _sizeBoxClassName)) {
          _expressions.add(expression);
        }
      }
    }
  }
}
