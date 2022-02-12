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
      _expressions.add(expression);
    }
  }
}
