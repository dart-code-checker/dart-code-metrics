part of 'avoid_ignoring_return_values_rule.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final _statements = <ExpressionStatement>[];

  Iterable<ExpressionStatement> get statements => _statements;

  @override
  void visitExpressionStatement(ExpressionStatement node) {
    super.visitExpressionStatement(node);

    final expression = node.expression;
    if (_isInvocationWithUnusedResult(expression) ||
        _isPropertyAccessWithUnusedResult(expression) ||
        _isAwaitWithUnusedResult(expression)) {
      _statements.add(node);
    }
  }

  bool _isInvocationWithUnusedResult(Expression expression) =>
      expression is InvocationExpression &&
      _hasUnusedResult(expression.staticType);

  bool _isPropertyAccessWithUnusedResult(Expression expression) =>
      (expression is PropertyAccess &&
          _hasUnusedResult(expression.staticType)) ||
      (expression is PrefixedIdentifier &&
          expression.staticElement?.kind == ElementKind.GETTER &&
          _hasUnusedResult(expression.staticType));

  bool _isAwaitWithUnusedResult(Expression expression) =>
      expression is AwaitExpression && _hasUnusedResult(expression.staticType);

  bool _hasUnusedResult(DartType? type) =>
      type != null &&
      !_isEmptyType(type) &&
      !_isEmptyFutureType(type) &&
      !_isEmptyFutureOrType(type);

  bool _isEmptyType(DartType type) =>
      // ignore: deprecated_member_use
      type.isBottom || type.isDartCoreNull || type.isVoid;

  bool _isEmptyFutureType(DartType type) =>
      type is InterfaceType &&
      type.isDartAsyncFuture &&
      type.typeArguments.any(_isEmptyType);

  bool _isEmptyFutureOrType(DartType type) =>
      type is InterfaceType &&
      type.isDartAsyncFutureOr &&
      type.typeArguments.any(_isEmptyType);
}
