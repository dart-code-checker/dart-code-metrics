part of 'avoid_passing_async_when_sync_expected_rule.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final _invalidArguments = <Expression>[];

  Iterable<Expression> get invalidArguments => _invalidArguments;

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    super.visitInstanceCreationExpression(node);
    _handleInvalidArguments(node.argumentList);
  }

  @override
  void visitMethodInvocation(MethodInvocation node) {
    super.visitMethodInvocation(node);
    _handleInvalidArguments(node.argumentList);
  }

  @override
  void visitFunctionExpressionInvocation(FunctionExpressionInvocation node) {
    super.visitFunctionExpressionInvocation(node);
    _handleInvalidArguments(node.argumentList);
  }

  void _handleInvalidArguments(ArgumentList arguments) {
    for (final argument in arguments.arguments) {
      final argumentType = argument.staticType;
      final parameterType = argument.staticParameterElement?.type;
      if (argumentType is FunctionType && parameterType is FunctionType) {
        if (argumentType.returnType.isDartAsyncFuture &&
            !_hasValidFutureType(parameterType.returnType)) {
          _invalidArguments.add(argument);
        }
      }
    }
  }

  bool _hasValidFutureType(DartType type) =>
      type.isDartAsyncFuture ||
      type.isDartAsyncFutureOr ||
      // ignore: deprecated_member_use
      type.isDynamic ||
      type.isDartCoreObject;
}
