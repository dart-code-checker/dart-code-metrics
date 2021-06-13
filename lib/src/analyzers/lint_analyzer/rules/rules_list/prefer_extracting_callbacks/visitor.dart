part of 'prefer_extracting_callbacks.dart';

class _Visitor extends SimpleAstVisitor<void> {
  final _expressions = <Expression>[];

  final Iterable<String> _ignoredArguments;

  Iterable<Expression> get expressions => _expressions;

  _Visitor(this._ignoredArguments);

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    final classType = node.extendsClause?.superclass.type;
    if (!isWidgetOrSubclass(classType) && !isWidgetStateOrSubclass(classType)) {
      return;
    }

    final visitor = _InstanceCreationVisitor(_ignoredArguments);
    node.visitChildren(visitor);

    _expressions.addAll(visitor.expressions);
  }
}

class _InstanceCreationVisitor extends RecursiveAstVisitor<void> {
  final _expressions = <Expression>[];

  final Iterable<String> _ignoredArguments;

  Iterable<Expression> get expressions => _expressions;

  _InstanceCreationVisitor(this._ignoredArguments);

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    for (final argument in node.argumentList.arguments) {
      final expression =
          argument is NamedExpression ? argument.expression : argument;

      if (_isNotIgnored(argument) &&
          expression is FunctionExpression &&
          expression.body is BlockFunctionBody) {
        _expressions.add(argument);
      }
    }
  }

  bool _isNotIgnored(Expression argument) =>
      argument is! NamedExpression ||
      (argument.name.label.name != 'builder' &&
          !_ignoredArguments.contains(argument.name.label.name));
}
