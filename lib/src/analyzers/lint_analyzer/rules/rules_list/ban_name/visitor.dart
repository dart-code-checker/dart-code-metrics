part of 'ban_name_rule.dart';

class _Visitor extends GeneralizingAstVisitor<void> {
  final Map<String, _BanNameConfigEntry> _entryMap;

  final _nodes = <_NodeWithMessage>[];

  Iterable<_NodeWithMessage> get nodes => _nodes;

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
