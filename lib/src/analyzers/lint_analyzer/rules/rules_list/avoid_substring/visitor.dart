part of 'avoid_substring_rule.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final _expressions = <Expression>[];

  Iterable<Expression> get expressions => _expressions;

  @override
  void visitMethodInvocation(MethodInvocation node) {
    super.visitMethodInvocation(node);
    if (_isNotSubstringMethod(node)) {
      return;
    }
    _expressions.add(node);
  }

  bool _isNotSubstringMethod(MethodInvocation node) =>
      node.methodName.name != 'substring';
}
