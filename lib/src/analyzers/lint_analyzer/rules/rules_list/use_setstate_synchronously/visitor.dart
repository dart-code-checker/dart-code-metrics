part of 'use_setstate_synchronously_rule.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final nodes = <SimpleIdentifier>[];

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    if (isWidgetStateOrSubclass(node.extendsClause?.superclass.type)) {
      final visitor = _AsyncSetStateVisitor();
      node.visitChildren(visitor);
      nodes.addAll(visitor.nodes);
    }
  }
}

class _AsyncSetStateVisitor extends RecursiveAstVisitor<void> {
  bool shouldBeMounted = true;
  final nodes = <SimpleIdentifier>[];

  @override
  void visitBlockFunctionBody(BlockFunctionBody node) {
    final oldMounted = shouldBeMounted;
    shouldBeMounted = true;
    node.visitChildren(this);
    shouldBeMounted = oldMounted;
  }

  @override
  void visitAwaitExpression(AwaitExpression node) {
    shouldBeMounted = false;
    super.visitAwaitExpression(node);
  }

  @override
  void visitMethodInvocation(MethodInvocation node) {
    // [this.]setState()
    if (!shouldBeMounted &&
        node.methodName.name == 'setState' &&
        node.target is ThisExpression?) {
      nodes.add(node.methodName);
    }

    super.visitMethodInvocation(node);
  }

  @override
  void visitIfStatement(IfStatement node) {
    node.condition.visitChildren(this);
    final oldMounted = shouldBeMounted;
    final newMounted = _extractMountedCheck(node.condition);
    shouldBeMounted = newMounted ?? shouldBeMounted;
    node.thenStatement.visitChildren(this);

    var elseDiverges = false;
    final elseStatement = node.elseStatement;
    if (elseStatement != null) {
      if (newMounted != null) {
        elseDiverges = _blockDiverges(elseStatement);
        shouldBeMounted = !shouldBeMounted;
      }
      elseStatement.visitChildren(this);
      if (newMounted != null) {
        shouldBeMounted = !shouldBeMounted;
      }
    }

    if (newMounted != null && _blockDiverges(node.thenStatement)) {
      shouldBeMounted = !shouldBeMounted;
    } else if (!elseDiverges) {
      shouldBeMounted = oldMounted;
    }
  }

  @override
  void visitWhileStatement(WhileStatement node) {
    node.condition.visitChildren(this);
    final oldMounted = shouldBeMounted;
    final newMounted = _extractMountedCheck(node.condition);
    shouldBeMounted = newMounted ?? shouldBeMounted;
    node.body.visitChildren(this);

    shouldBeMounted = newMounted != null && _blockDiverges(node.body)
        ? !shouldBeMounted
        : oldMounted;
  }
}
