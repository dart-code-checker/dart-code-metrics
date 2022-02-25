part of 'ban_name_rule.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final Map<String, _BanNameConfigEntry> _entryMap;

  final _nodes = <_NodeWithMessage>[];

  Iterable<_NodeWithMessage> get nodes => _nodes;

  _Visitor(List<_BanNameConfigEntry> entries)
      : _entryMap = Map.fromEntries(entries.map((e) => MapEntry(e.ident, e)));

  @override
  void visitSimpleIdentifier(SimpleIdentifier node) {
    super.visitSimpleIdentifier(node);
    _visitIdent(node, node);
  }

  @override
  void visitPrefixedIdentifier(PrefixedIdentifier node) {
    super.visitPrefixedIdentifier(node);
    _visitIdent(node, node.identifier);
    _visitIdent(node, node.prefix);
  }

  @override
  void visitLibraryIdentifier(LibraryIdentifier node) {
    super.visitLibraryIdentifier(node);
    for (final component in node.components) {
      _visitIdent(node, component);
    }
  }

  void _visitIdent(Expression node, SimpleIdentifier ident) {
    final name = ident.name;
    if (_entryMap.containsKey(name)) {
      _nodes.add(_NodeWithMessage(
        node,
        '${_entryMap[name]!.description} ($name is banned)',
      ));
    }
  }
}

class _NodeWithMessage {
  final Expression node;
  final String message;

  _NodeWithMessage(this.node, this.message);
}
