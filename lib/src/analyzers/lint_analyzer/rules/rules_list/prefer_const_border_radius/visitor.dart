part of 'prefer_const_border_radius_rule.dart';

const _borderRadiusClassName = 'BorderRadius';
const _borderRadiusConstructorName = 'circular';

class _Visitor extends RecursiveAstVisitor<void> {
  final _expressions = <InstanceCreationExpression>[];

  Iterable<InstanceCreationExpression> get expressions => _expressions;

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression expression) {
    super.visitInstanceCreationExpression(expression);

    final arguments = expression.argumentList.arguments;

    if (expression.staticType?.getDisplayString(withNullability: true) ==
            _borderRadiusClassName &&
        expression.constructorName.name?.name == _borderRadiusConstructorName &&
        arguments.length == 1) {
      final arg = arguments.first;

      if (arg is Literal) {
        _expressions.add(expression);
      } else if (arg is Identifier) {
        final element = arg.staticElement;
        if (element is PropertyAccessorElement && element.variable.isConst) {
          _expressions.add(expression);
        }
      }
    }
  }
}
