part of 'no_equal_arguments.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final _arguments = <Expression>[];

  final Iterable<String> _ignoredParameters;

  Iterable<Expression> get arguments => _arguments;

  _Visitor(this._ignoredParameters);

  @override
  void visitMethodInvocation(MethodInvocation node) {
    super.visitMethodInvocation(node);

    _visitArguments(node.argumentList.arguments);
  }

  @override
  void visitFunctionExpressionInvocation(FunctionExpressionInvocation node) {
    super.visitFunctionExpressionInvocation(node);

    _visitArguments(node.argumentList.arguments);
  }

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    super.visitInstanceCreationExpression(node);

    _visitArguments(node.argumentList.arguments);
  }

  void _visitArguments(NodeList<Expression> arguments) {
    final notIgnoredArguments = arguments.where(_isNotIgnored).toList();

    for (final argument in notIgnoredArguments) {
      final lastAppearance = notIgnoredArguments.lastWhere((arg) {
        if (argument is NamedExpression &&
            arg is NamedExpression &&
            argument.expression is! Literal &&
            arg.expression is! Literal) {
          return argument.expression.toString() == arg.expression.toString();
        }

        if (_bothLiterals(argument, arg)) {
          return argument == arg;
        }

        return argument.toString() == arg.toString();
      });

      if (argument != lastAppearance) {
        _arguments.add(lastAppearance);
      }
    }
  }

  bool _bothLiterals(Expression left, Expression right) =>
      left is Literal && right is Literal ||
      (left is PrefixExpression &&
          left.operand is Literal &&
          right is PrefixExpression &&
          right.operand is Literal);

  bool _isNotIgnored(Expression arg) => !(arg is NamedExpression &&
      _ignoredParameters.contains(arg.name.label.name));
}
