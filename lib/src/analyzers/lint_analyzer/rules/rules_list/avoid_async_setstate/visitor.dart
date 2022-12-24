part of 'avoid_async_setstate_rule.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final nodes = <SimpleIdentifier>[];

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    if (node.extendsClause?.superclass.name.name == 'State') {
      node.visitChildren(this);
    }
  }

  @override
  void visitBlock(Block node) {
    final visitor = _AsyncSetStateVisitor();
    node.visitChildren(visitor);

    nodes.addAll(visitor.nodes);
  }
}

class _AsyncSetStateVisitor extends RecursiveAstVisitor<void> {
  bool shouldBeMounted = true;
  final nodes = <SimpleIdentifier>[];

  @override
  void visitAwaitExpression(AwaitExpression node) {
    shouldBeMounted = false;
    node.visitChildren(this);
  }

  @override
  void visitMethodInvocation(MethodInvocation node) {
    // [this.]setState()
    if (!shouldBeMounted &&
        node.methodName.name == 'setState' &&
        node.target is ThisExpression?) {
      nodes.add(node.methodName);
    }

    node.visitChildren(this);
  }

  @override
  void visitIfStatement(IfStatement node) {
    node.condition.visitChildren(this);

    final oldMounted = shouldBeMounted;
    final newMounted = _extractMountedCheck(node.condition);
    shouldBeMounted = newMounted ?? shouldBeMounted;
    node.thenStatement.visitChildren(this);

    var elseDiverges = false;
    final elseStmt = node.elseStatement;
    if (elseStmt != null) {
      if (newMounted != null) {
        elseDiverges = _blockDiverges(elseStmt);
        shouldBeMounted = !shouldBeMounted;
      }
      elseStmt.visitChildren(this);
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

    shouldBeMounted = _blockDiverges(node.body) && newMounted != null
        ? !shouldBeMounted
        : oldMounted;
  }
}
