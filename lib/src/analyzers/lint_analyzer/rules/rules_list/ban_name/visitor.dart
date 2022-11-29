part of 'ban_name_rule.dart';

class _Visitor extends GeneralizingAstVisitor<void> {
  final Map<String, _BanNameConfigEntry> _entryMap;

  final _nodes = <_NodeInfo>[];

  Iterable<_NodeInfo> get nodes => _nodes;

  final _visitedNodes = <AstNode>{};

  _Visitor(List<_BanNameConfigEntry> entries)
      : _entryMap = Map.fromEntries(entries.map((e) => MapEntry(e.ident, e)));

  @override
  void visitSimpleIdentifier(SimpleIdentifier node) {
    _visitIdent(node, node);
  }

  @override
  void visitPrefixedIdentifier(PrefixedIdentifier node) {
    _visitIdent(node, node.identifier);
    _visitIdent(node, node.prefix);
  }

  @override
  void visitLibraryIdentifier(LibraryIdentifier node) {
    for (final component in node.components) {
      _visitIdent(node, component);
    }
  }

  @override
  void visitDeclaration(Declaration node) {
    final name = node.declaredElement?.displayName;
    if (name != null) {
      _checkBannedName(node, name);
    }

    super.visitDeclaration(node);
  }

  void _visitIdent(AstNode node, SimpleIdentifier name) {
    _checkBannedName(name, name.name);

    if (node is PrefixedIdentifier) {
      _checkBannedName(node, node.name);
    }

    _traverseParents(name.parent);
  }

  void _traverseParents(AstNode? node) {
    if (node is MethodInvocation) {
      _checkBannedName(
        node,
        '${node.realTarget}.${node.methodName}',
      );
      _traverseParents(node.parent);
    }

    if (node is PropertyAccess) {
      _checkBannedName(
        node,
        '${node.realTarget}.${node.propertyName}',
      );
      _traverseParents(node.realTarget);
    }

    if (node is ConstructorName) {
      _traverseParents(node.parent);
    }

    if (node is InstanceCreationExpression) {
      _checkBannedName(node, node.constructorName.toString());
    }
  }

  void _checkBannedName(AstNode node, String name) {
    if (_entryMap.containsKey(name) && !_visitedNodes.contains(node)) {
      _visitedNodes.add(node);
      _nodes.add(_NodeInfo(
        node,
        message: '${_entryMap[name]!.description} ($name is banned)',
      ));
    }
  }
}

class _NodeInfo {
  final AstNode node;
  final String message;

  _NodeInfo(
    this.node, {
    required this.message,
  });
}
