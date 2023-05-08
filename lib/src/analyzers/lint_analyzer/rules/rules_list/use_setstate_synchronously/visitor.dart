part of 'use_setstate_synchronously_rule.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final Set<String> methods;

  _Visitor({required this.methods});

  final nodes = <SimpleIdentifier>[];

  @override
  void visitCompilationUnit(CompilationUnit node) {
    for (final declaration in node.declarations) {
      if (declaration is ClassDeclaration) {
        final type = declaration.extendsClause?.superclass.type;
        if (isWidgetStateOrSubclass(type)) {
          declaration.visitChildren(this);
        }
      }
    }
  }

  @override
  void visitBlockFunctionBody(BlockFunctionBody node) {
    if (!node.isAsynchronous) {
      return node.visitChildren(this);
    }
    final visitor = _AsyncSetStateVisitor(validateMethod: methods.contains);
    node.visitChildren(visitor);
    nodes.addAll(visitor.nodes);
  }
}

class _AsyncSetStateVisitor extends RecursiveAstVisitor<void> {
  static bool _noop(String _) => false;

  bool Function(String) validateMethod;
  _AsyncSetStateVisitor({this.validateMethod = _noop});

  MountedFact mounted = true.asFact();
  bool inControlFlow = false;
  bool inAsync = true;

  bool get isMounted => mounted.value ?? false;
  final nodes = <SimpleIdentifier>[];

  @override
  void visitAwaitExpression(AwaitExpression node) {
    mounted = false.asFact();
    super.visitAwaitExpression(node);
  }

  @override
  void visitAssertStatement(AssertStatement node) {
    final newMounted = _extractMountedCheck(node.condition);
    mounted = newMounted.or(mounted);
    super.visitAssertStatement(node);
  }

  @override
  void visitMethodInvocation(MethodInvocation node) {
    if (!inAsync) {
      return node.visitChildren(this);
    }

    // [this.]setState()
    if (!isMounted &&
        validateMethod(node.methodName.name) &&
        node.target is ThisExpression?) {
      nodes.add(node.methodName);
    }

    super.visitMethodInvocation(node);
  }

  @override
  void visitIfStatement(IfStatement node) {
    if (!inAsync) {
      return node.visitChildren(this);
    }

    // ignore: deprecated_member_use
    node.condition.accept(this);

    // ignore: deprecated_member_use
    final newMounted = _extractMountedCheck(node.condition);
    mounted = newMounted.or(mounted);

    final beforeThen = mounted;
    node.thenStatement.visitChildren(this);
    final afterThen = mounted;

    var elseDiverges = false;
    final elseStatement = node.elseStatement;
    if (elseStatement != null) {
      elseDiverges = _blockDiverges(
        elseStatement,
        allowControlFlow: inControlFlow,
      );
      mounted = _tryInvert(newMounted).or(mounted);
      elseStatement.visitChildren(this);
    }

    if (_blockDiverges(node.thenStatement, allowControlFlow: inControlFlow)) {
      mounted = _tryInvert(newMounted).or(beforeThen);
    } else if (elseDiverges) {
      mounted = beforeThen != afterThen
          ? afterThen
          // ignore: deprecated_member_use
          : _extractMountedCheck(node.condition, permitAnd: false);
    }
  }

  @override
  void visitWhileStatement(WhileStatement node) {
    if (!inAsync) {
      return node.visitChildren(this);
    }

    node.condition.accept(this);

    final oldMounted = mounted;
    final newMounted = _extractMountedCheck(node.condition);
    mounted = newMounted.or(mounted);
    final oldInControlFlow = inControlFlow;
    inControlFlow = true;
    node.body.visitChildren(this);

    if (_blockDiverges(node.body, allowControlFlow: inControlFlow)) {
      mounted = _tryInvert(newMounted).or(oldMounted);
    }

    inControlFlow = oldInControlFlow;
  }

  @override
  void visitForStatement(ForStatement node) {
    if (!inAsync) {
      return node.visitChildren(this);
    }

    node.forLoopParts.accept(this);

    final oldInControlFlow = inControlFlow;
    inControlFlow = true;

    node.body.visitChildren(this);

    inControlFlow = oldInControlFlow;
  }

  @override
  void visitBlockFunctionBody(BlockFunctionBody node) {
    final oldMounted = mounted;
    final oldInAsync = inAsync;
    mounted = true.asFact();
    inAsync = node.isAsynchronous;

    node.visitChildren(this);

    mounted = oldMounted;
    inAsync = oldInAsync;
  }

  @override
  void visitTryStatement(TryStatement node) {
    if (!inAsync) {
      return node.visitChildren(this);
    }

    final oldMounted = mounted;
    node.body.visitChildren(this);
    final afterBody = mounted;
    final beforeCatch =
        mounted == oldMounted ? oldMounted : false.asFact<BinaryExpression>();
    for (final clause in node.catchClauses) {
      mounted = beforeCatch;
      clause.visitChildren(this);
    }

    final finallyBlock = node.finallyBlock;
    if (finallyBlock != null) {
      mounted = beforeCatch;
      finallyBlock.visitChildren(this);
    } else {
      mounted = afterBody;
    }
  }

  @override
  void visitSwitchStatement(SwitchStatement node) {
    if (!inAsync) {
      return node.visitChildren(this);
    }

    node.expression.accept(this);

    final oldInControlFlow = inControlFlow;
    inControlFlow = true;

    final caseInvariant = mounted;
    for (final arm in node.members) {
      arm.visitChildren(this);
      if (mounted != caseInvariant &&
          !_caseDiverges(arm, allowControlFlow: false)) {
        mounted = false.asFact();
      }

      if (_caseDiverges(arm, allowControlFlow: true)) {
        mounted = caseInvariant;
      }
    }

    inControlFlow = oldInControlFlow;
  }
}
