part of 'avoid_redundant_async_rule.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final _declarations = <Declaration>[];

  Iterable<Declaration> get declarations => _declarations;

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    super.visitMethodDeclaration(node);

    if (!isOverride(node.metadata) && _hasRedundantAsync(node.body)) {
      _declarations.add(node);
    }
  }

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    super.visitFunctionDeclaration(node);

    if (_hasRedundantAsync(node.functionExpression.body)) {
      _declarations.add(node);
    }
  }

  bool _hasRedundantAsync(FunctionBody body) {
    final hasAsyncKeyword = body.keyword?.type == Keyword.ASYNC;
    if (!hasAsyncKeyword) {
      return false;
    }

    if (body is ExpressionFunctionBody) {
      final type = body.expression.staticType;

      if (type != null && !type.isDartAsyncFuture) {
        return false;
      }
    }

    final asyncVisitor = _AsyncVisitor();
    body.parent?.visitChildren(asyncVisitor);

    return !asyncVisitor.hasValidAsync;
  }
}

class _AsyncVisitor extends RecursiveAstVisitor<void> {
  bool hasValidAsync = false;

  @override
  void visitReturnStatement(ReturnStatement node) {
    super.visitReturnStatement(node);

    final type = node.expression?.staticType;

    if (type == null ||
        !type.isDartAsyncFuture ||
        type.nullabilitySuffix == NullabilitySuffix.question) {
      hasValidAsync = true;
    }
  }

  @override
  void visitThrowExpression(ThrowExpression node) {
    super.visitThrowExpression(node);

    hasValidAsync = true;
  }

  @override
  void visitAwaitExpression(AwaitExpression node) {
    super.visitAwaitExpression(node);

    hasValidAsync = true;
  }

  @override
  void visitYieldStatement(YieldStatement node) {
    super.visitYieldStatement(node);

    hasValidAsync = true;
  }
}
