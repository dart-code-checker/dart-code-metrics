part of 'prefer_async_await_rule.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final _invocations = <MethodInvocation>[];

  Iterable<MethodInvocation> get invocations => _invocations;

  @override
  void visitMethodInvocation(MethodInvocation node) {
    super.visitMethodInvocation(node);

    final target = node.realTarget;

    if ((target?.staticType?.isDartAsyncFuture ?? false) &&
        node.methodName.name == 'then') {
      _invocations.add(node);
    }
  }
}
