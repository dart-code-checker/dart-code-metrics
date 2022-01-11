part of 'prefer_extracting_callbacks_rule.dart';

class _Visitor extends SimpleAstVisitor<void> {
  final _expressions = <Expression>[];

  final Iterable<String> _ignoredArguments;

  Iterable<Expression> get expressions => _expressions;

  _Visitor(this._ignoredArguments);

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    final classType = node.extendsClause?.superclass2.type;
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
    super.visitInstanceCreationExpression(node);

    for (final argument in node.argumentList.arguments) {
      final expression =
          argument is NamedExpression ? argument.expression : argument;

      if (_isNotIgnored(argument) &&
          expression is FunctionExpression &&
          _hasNotEmptyBlockBody(expression) &&
          !_isFlutterBuilder(expression)) {
        _expressions.add(argument);
      }
    }
  }

  bool _hasNotEmptyBlockBody(FunctionExpression expression) {
    final body = expression.body;
    if (body is! BlockFunctionBody) {
      return false;
    }

    return body.block.statements.isNotEmpty;
  }

  bool _isFlutterBuilder(FunctionExpression expression) {
    if (!isWidgetOrSubclass(expression.declaredElement?.returnType)) {
      return false;
    }

    final formalParameters = expression.parameters?.parameters;

    return formalParameters == null ||
        formalParameters.isNotEmpty &&
            isBuildContext(formalParameters.first.declaredElement?.type);
  }

  bool _isNotIgnored(Expression argument) =>
      argument is! NamedExpression ||
      !_ignoredArguments.contains(argument.name.label.name);
}
