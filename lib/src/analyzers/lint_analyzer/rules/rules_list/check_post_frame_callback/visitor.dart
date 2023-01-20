part of 'check_post_frame_callback_rule.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final _expressions = <MethodInvocation>[];

  Iterable<MethodInvocation> get expressions => _expressions;

  @override
  void visitMethodInvocation(MethodInvocation node) {
    super.visitMethodInvocation(node);

    if (node.methodName.name == 'addPostFrameCallback' &&
        node.operator?.type == TokenType.QUESTION_PERIOD &&
        node.target.toString() == 'WidgetsBinding.instance') {
      _expressions.add(node);
    }
  }
}
