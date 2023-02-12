part of 'no_equal_arguments_rule.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final _arguments = <Expression>[];

  final Iterable<String> _ignoredParameters;
  final Iterable<String> _ignoredArguments;

  Iterable<Expression> get arguments => _arguments;

  _Visitor(this._ignoredParameters, this._ignoredArguments);

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

  void _visitArguments(Iterable<Expression> arguments) {
    final notIgnoredArguments = arguments.whereNot(_isIgnored).toList();

    for (final argument in notIgnoredArguments) {
      final lastAppearance = notIgnoredArguments.lastWhere((arg) {
        if (argument is NamedExpression &&
            arg is NamedExpression &&
            argument.expression is! Literal &&
            arg.expression is! Literal) {
          return haveSameParameterType(argument.expression, arg.expression) &&
              argument.expression.toString() == arg.expression.toString();
        }

        if (_bothLiterals(argument, arg)) {
          return argument == arg;
        }

        return haveSameParameterType(argument, arg) &&
            argument.toString() == arg.toString();
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

  bool _isIgnored(Expression arg) {
    if (arg is NamedExpression) {
      final expression = arg.expression;

      return _ignoredParameters.contains(arg.name.label.name) ||
          (expression is SimpleIdentifier &&
              _ignoredArguments.contains(expression.name));
    }

    return arg is SimpleIdentifier && _ignoredArguments.contains(arg.name);
  }
}
