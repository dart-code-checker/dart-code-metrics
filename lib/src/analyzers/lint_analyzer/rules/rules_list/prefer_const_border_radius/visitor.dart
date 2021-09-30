part of 'prefer_const_border_radius.dart';

const borderRadiusClassName = 'BorderRadius';
const borderRadiusConstructorName = 'circular';

class _Visitor extends RecursiveAstVisitor<void> {
  final _expressions = <InstanceCreationExpression>[];

  Iterable<InstanceCreationExpression> get expressions => _expressions;

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression expression) {
    super.visitInstanceCreationExpression(expression);

    if (expression.staticType?.getDisplayString(withNullability: true) ==
            borderRadiusClassName &&
        expression.constructorName.name?.name == borderRadiusConstructorName &&
        expression.argumentList.arguments.length == 1) {
      final arg = expression.argumentList.arguments.first;

      if (arg is Literal) {
        _expressions.add(expression);
      } else if (arg is Identifier) {
        final element = arg.staticElement;
        if (element is PropertyAccessorElement && element.variable.isConst) {
          _expressions.add(expression);
        }
      } else if (arg is BinaryExpression) {
        // TODO(grafov): check result of binary expression
      }
    }
  }
}
