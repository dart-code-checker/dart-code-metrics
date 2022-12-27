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
  MountedFact mounted = true.asFact();
  bool inFlow = false;
  final nodes = <SimpleIdentifier>[];

  @override
  void visitBlockFunctionBody(BlockFunctionBody node) {
    final oldMounted = mounted;
    mounted = true.asFact();
    node.visitChildren(this);
    mounted = oldMounted;
  }

  @override
  void visitAwaitExpression(AwaitExpression node) {
    mounted = false.asFact();
    super.visitAwaitExpression(node);
  }

  @override
  void visitMethodInvocation(MethodInvocation node) {
    // [this.]setState()
    final mounted_ = mounted.value ?? false;
    if (!mounted_ &&
        node.methodName.name == 'setState' &&
        node.target is ThisExpression?) {
      nodes.add(node.methodName);
    }

    super.visitMethodInvocation(node);
  }

  @override
  void visitIfStatement(IfStatement node) {
    node.condition.visitChildren(this);
    final oldMounted = mounted;
    final newMounted = _extractMountedCheck(node.condition);

    mounted = newMounted.or(mounted);
    final beforeThen = mounted;
    node.thenStatement.visitChildren(this);
    final afterThen = mounted;

    var elseDiverges = false;
    final elseStatement = node.elseStatement;
    if (elseStatement != null) {
      elseDiverges = _blockDiverges(elseStatement);
      mounted = _tryInvert(newMounted);
      elseStatement.visitChildren(this);
    }

    if (_blockDiverges(node.thenStatement)) {
      mounted = _tryInvert(newMounted);
    } else if (elseDiverges) {
      mounted = beforeThen != afterThen
          ? afterThen
          : _extractMountedCheck(node.condition, permitAnd: false);
    } else {
      mounted = oldMounted;
    }
  }

  @override
  void visitWhileStatement(WhileStatement node) {
    node.condition.visitChildren(this);
    final oldMounted = mounted;
    final newMounted = _extractMountedCheck(node.condition);
    mounted = newMounted.or(mounted);
    node.body.visitChildren(this);

    mounted = _blockDiverges(node.body) ? _tryInvert(newMounted) : oldMounted;
  }
}
