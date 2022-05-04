part of 'prefer_moving_to_variable_rule.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final _nodes = <AstNode>[];

  Iterable<AstNode> get nodes => _nodes;

  @override
  void visitBlockFunctionBody(BlockFunctionBody node) {
    final visitor = _BlockVisitor();
    node.visitChildren(visitor);

    _nodes.addAll(visitor.duplicates);
  }
}

class _BlockVisitor extends RecursiveAstVisitor<void> {
  final Map<String, AstNode> _visitedInvocations = {};
  final Set<AstNode> _visitedNodes = {};
  final Set<AstNode> _duplicates = {};

  Set<AstNode> get duplicates => _duplicates;

  _BlockVisitor();

  @override
  void visitPropertyAccess(PropertyAccess node) {
    if (node.target == null) {
      return;
    }

    final hasDuplicates = _checkForDuplicates(node, node.target);
    if (!hasDuplicates) {
      super.visitPropertyAccess(node);
    }
  }

  @override
  void visitMethodInvocation(MethodInvocation node) {
    if (node.parent is CascadeExpression ||
        (node.staticType?.isVoid ?? false)) {
      return;
    }

    final hasDuplicates = _checkForDuplicates(node, node.target);
    if (!hasDuplicates) {
      super.visitMethodInvocation(node);
    }
  }

  bool _checkForDuplicates(AstNode node, Expression? target) {
    final access = node.toString();
    final visitedInvocation = _visitedInvocations[access];
    final isDuplicate =
        visitedInvocation != null && _isDuplicate(visitedInvocation, node);
    if (isDuplicate) {
      _duplicates.addAll([visitedInvocation!, node]);
    }

    if (_visitedNodes.contains(node)) {
      return isDuplicate;
    }

    _visitedInvocations[access] = node;
    _visitAllTargets(target);

    return false;
  }

  bool _isDuplicate(AstNode visitedInvocation, AstNode node) {
    final visitedSwitch =
        visitedInvocation.thisOrAncestorOfType<SwitchStatement>();

    final visitedBlock = visitedInvocation.thisOrAncestorOfType<Block>();
    final parentBlock = node.thisOrAncestorOfType<Block>();

    // ignore: avoid-late-keyword
    final grandParentBlock = parentBlock?.thisOrAncestorMatching(
      (block) => block is Block && block != parentBlock,
    );

    final visitedFunctionExpression = visitedInvocation.thisOrAncestorMatching(
      (astNode) =>
          astNode is FunctionExpression || astNode is FunctionDeclaration,
    );
    final parentFunctionExpression = node.thisOrAncestorMatching((astNode) =>
        astNode is FunctionExpression || astNode is FunctionDeclaration);

    return visitedInvocation != node &&
        visitedSwitch == null &&
        (visitedBlock == parentBlock || visitedBlock == grandParentBlock) &&
        (visitedFunctionExpression == null &&
                parentFunctionExpression == null ||
            visitedFunctionExpression == parentFunctionExpression);
  }

  void _visitAllTargets(Expression? target) {
    var realTarget = target;

    while (realTarget != null) {
      _visitedNodes.add(realTarget);

      final access = realTarget.toString();
      if (!_visitedInvocations.containsKey(access)) {
        _visitedInvocations[access] = realTarget;
      }

      if (realTarget is MethodInvocation) {
        realTarget = realTarget.realTarget;
      } else if (realTarget is PropertyAccess) {
        realTarget = realTarget.realTarget;
      } else {
        realTarget = null;
      }
    }
  }
}
