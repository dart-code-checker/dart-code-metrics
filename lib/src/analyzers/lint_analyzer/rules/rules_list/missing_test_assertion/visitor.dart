part of 'missing_test_assertion_rule.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final _nodes = <AstNode>[];

  Iterable<AstNode> get nodes => _nodes;

  final Iterable<String> _includeAssertions;
  final Iterable<String> _includeMethods;

  _Visitor(this._includeAssertions, this._includeMethods);

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    super.visitFunctionDeclaration(node);
    if (node.name.toString() != 'main') {
      return;
    }

    final visitor = _MethodTestVisitor(_includeAssertions, _includeMethods);
    node.visitChildren(visitor);
    _nodes.addAll(visitor.nodes);
  }
}

class _MethodTestVisitor extends RecursiveAstVisitor<void> {
  final _testMethodNameList = <String>{
    'test',
    'testWidgets',
  };

  final _nodes = <AstNode>[];

  Iterable<AstNode> get nodes => _nodes;

  final Iterable<String> _includeAssertions;

  _MethodTestVisitor(this._includeAssertions, Iterable<String> includeMethods) {
    _testMethodNameList.addAll(includeMethods);
  }

  @override
  void visitMethodInvocation(MethodInvocation node) {
    super.visitMethodInvocation(node);
    if (!_testMethodNameList.contains(node.methodName.toString())) {
      return;
    }

    final visitor = _MethodAssertionVisitor(_includeAssertions);
    node.visitChildren(visitor);
    if (visitor.hasContainedAssertion) {
      return;
    }

    _nodes.add(node);
  }
}

class _MethodAssertionVisitor extends RecursiveAstVisitor<void> {
  final _assertionMethodNameList = <String>{
    'expect',
    'expectAsync0',
    'expectAsync1',
    'expectAsync2',
    'expectAsync3',
    'expectAsync4',
    'expectAsync5',
    'expectAsync6',
    'expectAsyncUntil0',
    'expectAsyncUntil1',
    'expectAsyncUntil2',
    'expectAsyncUntil3',
    'expectAsyncUntil4',
    'expectAsyncUntil5',
    'expectAsyncUntil6',
    'expectLater',
    'fail',
  };

  _MethodAssertionVisitor(Iterable<String> includeAssertions) {
    _assertionMethodNameList.addAll(includeAssertions);
  }

  bool hasContainedAssertion = false;

  @override
  void visitMethodInvocation(MethodInvocation node) {
    super.visitMethodInvocation(node);
    if (_assertionMethodNameList.contains(node.methodName.name)) {
      hasContainedAssertion = true;
    }
  }
}
