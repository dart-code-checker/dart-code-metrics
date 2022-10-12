part of 'ban_name_rule.dart';

class _Visitor extends GeneralizingAstVisitor<void> {
  final Map<String, _BanNameConfigEntry> _entryMap;

  final _nodes = <_NodeWithMessage>[];

  Iterable<_NodeWithMessage> get nodes => _nodes;

  final _nodeBreadcrumb = <String, AstNode>{};

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
    if (prevNode == null || node.offset == (prevNode.end + 1)) {
      _nodeBreadcrumb.addAll({name: node});
    } else {
      _nodeBreadcrumb.clear();
    }

    final breadcrumbString = _nodeBreadcrumb.keys.join('.');
    if (_entryMap.containsKey(breadcrumbString)) {
      _nodes.add(_NodeWithMessage(
        _nodeBreadcrumb.values.first,
        '${_entryMap[breadcrumbString]!.description} ($breadcrumbString is banned)',
      ));
      return;
    }

    if (_entryMap.containsKey(name)) {
      _nodes.add(_NodeWithMessage(
        node,
        '${_entryMap[name]!.description} ($name is banned)',
      ));
    }
  }
}

class _NodeWithMessage {
  final AstNode node;
  final String message;

  _NodeWithMessage(this.node, this.message);
}
