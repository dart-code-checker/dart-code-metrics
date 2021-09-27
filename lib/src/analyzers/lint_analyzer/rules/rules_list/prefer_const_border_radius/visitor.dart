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
      expressions.first.isConst;

      final argument = expression.argumentList.arguments.first;

      _expressions.add(expression);
    }
  }
}
