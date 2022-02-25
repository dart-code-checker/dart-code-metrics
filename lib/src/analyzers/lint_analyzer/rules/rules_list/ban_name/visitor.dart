part of 'ban_name_rule.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final List<_BanNameConfigEntry> _entries;

  final _nodes = <_NodeWithMessage>[];

  Iterable<_NodeWithMessage> get nodes => _nodes;

  _Visitor(this._entries);
}

class _NodeWithMessage {
  final Expression node;
  final String message;

  _NodeWithMessage(this.node, this.message);
}
