part of 'prefer_extracting_callbacks.dart';

class _Visitor extends SimpleAstVisitor<void> {
  final _expressions = <Expression>[];

  Iterable<Expression> get expressions => _expressions;

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    final classType = node.extendsClause?.superclass.type;
    if (!isWidgetOrSubclass(classType) && !isStateOrSubclass(classType)) {
      return;
    }

    final visitor = _InstanceCreationVisitor();
    node.visitChildren(visitor);

    _expressions.addAll(visitor.expressions);
  }
}

class _InstanceCreationVisitor extends RecursiveAstVisitor<void> {
  final _expressions = <Expression>[];

  Iterable<Expression> get expressions => _expressions;

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    for (final argument in node.argumentList.arguments) {
      final expression =
          argument is NamedExpression ? argument.expression : argument;

      if (expression is FunctionExpression &&
          expression.body is BlockFunctionBody) {
        _expressions.add(argument);
      }
    }
  }
}
