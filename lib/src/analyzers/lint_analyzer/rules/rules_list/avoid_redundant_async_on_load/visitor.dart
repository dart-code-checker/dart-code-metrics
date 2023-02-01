part of 'avoid_redundant_async_on_load_rule.dart';

class _Visitor extends SimpleAstVisitor<void> {
  final _declarations = <MethodDeclaration>[];

  Iterable<MethodDeclaration> get declarations => _declarations;

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    super.visitClassDeclaration(node);

    final type = node.extendsClause?.superclass.type;
    if (type == null || !isComponentOrSubclass(type)) {
      return;
    }

    final onLoadMethod = node.members.firstWhereOrNull((member) =>
        member is MethodDeclaration &&
        member.name.lexeme == 'onLoad' &&
        isOverride(member.metadata));

    if (onLoadMethod is MethodDeclaration) {
      if (_hasFutureType(onLoadMethod.returnType?.type) &&
          _hasRedundantAsync(onLoadMethod.body)) {
        _declarations.add(onLoadMethod);
      }
    }
  }

  bool _hasFutureType(DartType? type) =>
      type != null && (type.isDartAsyncFuture || type.isDartAsyncFutureOr);

  bool _hasRedundantAsync(FunctionBody body) {
    if (body is ExpressionFunctionBody) {
      final type = body.expression.staticType;

      if (type != null &&
          (type.isDartAsyncFuture || type.isDartAsyncFutureOr)) {
        return false;
      }
    }

    final asyncVisitor = _AsyncVisitor(body);
    body.parent?.visitChildren(asyncVisitor);

    return !asyncVisitor.hasValidAsync;
  }
}

class _AsyncVisitor extends RecursiveAstVisitor<void> {
  final FunctionBody body;

  bool hasValidAsync = false;

  _AsyncVisitor(this.body);

  @override
  void visitReturnStatement(ReturnStatement node) {
    super.visitReturnStatement(node);

    hasValidAsync = true;
  }

  @override
  void visitAwaitExpression(AwaitExpression node) {
    super.visitAwaitExpression(node);

    hasValidAsync = true;
  }
}
