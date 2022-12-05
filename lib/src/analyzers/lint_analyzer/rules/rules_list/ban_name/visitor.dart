part of 'ban_name_rule.dart';

class _Visitor extends GeneralizingAstVisitor<void> {
  final Map<String, _BanNameConfigEntry> _entryMap;

  final _nodeBreadcrumb = <String, AstNode>{};
  final _nodes = <_NodeInfo>[];

  Iterable<_NodeInfo> get nodes => _nodes;

  _Visitor(List<_BanNameConfigEntry> entries)
      : _entryMap = Map.fromEntries(entries.map((e) => MapEntry(e.ident, e)));

  @override
  void visitSimpleIdentifier(SimpleIdentifier node) {
    _visitIdent(node, node.name);
  }

  @override
  void visitPrefixedIdentifier(PrefixedIdentifier node) {
    _visitIdent(node, node.identifier.name);
    _visitIdent(node, node.prefix.name);
  }

  @override
  void visitLibraryIdentifier(LibraryIdentifier node) {
    for (final component in node.components) {
      _visitIdent(node, component.name);
    }
  }

  @override
  void visitDeclaration(Declaration node) {
    final name = node.declaredElement?.displayName;
    if (name != null) {
      _visitIdent(node, name);
    }

    super.visitDeclaration(node);
  }

  void _visitIdent(AstNode node, String name) {
    final prevNode =
        _nodeBreadcrumb.isNotEmpty ? _nodeBreadcrumb.values.last : null;
    if (node.offset - 1 == prevNode?.end) {
      _nodeBreadcrumb.addAll({name: node});
    } else {
      _nodeBreadcrumb.clear();
    }

    if (_nodeBreadcrumb.isEmpty) {
      _nodeBreadcrumb.addAll({name: node});
    }

    if (_entryMap.containsKey(name)) {
      _nodes.add(_NodeInfo(
        node,
        fullName: name,
        message: '${_entryMap[name]!.description} ($name is banned)',
      ));

      return;
    }

    final breadcrumbString = _nodeBreadcrumb.keys.join('.');
    if (_entryMap.containsKey(breadcrumbString)) {
      _nodes.add(_NodeInfo(
        _nodeBreadcrumb.values.first,
        fullName: breadcrumbString,
        message:
            '${_entryMap[breadcrumbString]!.description} ($breadcrumbString is banned)',
        endNode: _nodeBreadcrumb.values.last,
      ));
    }
  }
}

class _NodeInfo {
  final AstNode node;
  final String fullName;
  final String message;
  final AstNode? endNode;

  _NodeInfo(
    this.node, {
    required this.fullName,
    required this.message,
    this.endNode,
  });
}
