part of 'prefer_moving_to_variable_rule.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final _nodes = <AstNode>[];

  final int? _duplicatesThreshold;

  Iterable<AstNode> get nodes => _nodes;

  _Visitor(this._duplicatesThreshold);

  @override
  void visitBlockFunctionBody(BlockFunctionBody node) {
    final visitor = _BlockVisitor(_duplicatesThreshold);
    node.visitChildren(visitor);

    _nodes.addAll(visitor.duplicates);
  }
}

class _BlockVisitor extends RecursiveAstVisitor<void> {
  final Map<String, AstNode> _visitedInvocations = {};
  final Set<AstNode> _visitedNodes = {};
  final Map<String, Set<AstNode>> _duplicates = {};

  final int? _duplicatesThreshold;

  Set<AstNode> get duplicates =>
      _duplicates.entries.fold(<AstNode>{}, (previousValue, element) {
        final duplicatesThreshold = _duplicatesThreshold;
        if (duplicatesThreshold == null ||
            element.value.length >= duplicatesThreshold) {
          previousValue.addAll(element.value);
        }

        return previousValue;
      });

  _BlockVisitor(this._duplicatesThreshold);

  @override
  void visitPropertyAccess(PropertyAccess node) {
    final target = node.target;
    if (target == null) {
      return;
    }

    if (target is PrefixedIdentifier) {
      final element = target.identifier.staticElement;
      if (element is EnumElement || element is ClassElement) {
        return;
      }
    }

    final hasDuplicates = _checkForDuplicates(node, node.target);
    if (!hasDuplicates) {
      super.visitPropertyAccess(node);
    }
  }

  @override
  void visitMethodInvocation(MethodInvocation node) {
    if (node.parent is CascadeExpression ||
        node.parent is VariableDeclaration ||
        (node.staticType?.isVoid ?? false)) {
      return;
    }

    final hasDuplicates = _checkForDuplicates(node, node.target);
    if (!hasDuplicates) {
      super.visitMethodInvocation(node);
    }
  }

  bool _checkForDuplicates(AstNode node, Expression? target) {
    final access = _extractAccess(node);
    final visitedInvocation = _visitedInvocations[access];
    final isDuplicate =
        visitedInvocation != null && _isDuplicate(visitedInvocation, node);
    if (isDuplicate) {
      _duplicates.update(
        access,
        (value) => value..addAll([visitedInvocation, node]),
        ifAbsent: () => {visitedInvocation, node},
      );
    }

    if (_visitedNodes.contains(node)) {
      return isDuplicate;
    }

    _visitedInvocations[access] = node;
    _visitAllTargets(target);

    return false;
  }

  String _extractAccess(AstNode node) {
    final parent = node.parent;
    if (parent is FunctionExpressionInvocation) {
      final typeArguments = parent.typeArguments;
      if (typeArguments != null && typeArguments.arguments.isNotEmpty) {
        return parent.toString();
      }
    }

    return node.toString();
  }

  bool _isDuplicate(AstNode visitedInvocation, AstNode node) {
    final visitedSwitch =
        visitedInvocation.thisOrAncestorOfType<SwitchStatement>();

    final visitedBlock = visitedInvocation.thisOrAncestorOfType<Block>();
    final parentBlock = node.thisOrAncestorOfType<Block>();

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
