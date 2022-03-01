part of 'avoid_border_all_rule.dart';

const _className = 'Border';
const _borderRadiusConstructorName = 'all';

class _Visitor extends RecursiveAstVisitor<void> {
  final _expressions = <InstanceCreationExpression>[];

  Iterable<InstanceCreationExpression> get expressions => _expressions;

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression expression) {
    super.visitInstanceCreationExpression(expression);

    if (expression.staticType?.getDisplayString(withNullability: true) ==
            _className &&
        expression.constructorName.name?.name == _borderRadiusConstructorName) {
      expression.argumentList.arguments.map((e) => null);

      var isAllConst = true;

      for (final argument in expression.argumentList.arguments) {
        final arg = (argument as NamedExpression).expression;
        if (arg is Literal) {
          continue;
        } else if (arg is MethodInvocation || arg is ConditionalExpression) {
          isAllConst = false;
        } else if (arg is SimpleIdentifier) {
          final element = arg.staticElement;
          if (element is PropertyAccessorElement && !element.variable.isConst) {
            isAllConst = false;
          }
        }
      }

      if (isAllConst) {
        _expressions.add(expression);
      }
    }
  }
}
