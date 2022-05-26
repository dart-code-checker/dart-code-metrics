part of 'avoid_banned_imports_rule.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final List<_AvoidBannedImportsConfigEntry> entries;

  final _nodes = <_NodeWithMessage>[];

  Iterable<_NodeWithMessage> get nodes => _nodes;

  _Visitor(this.entries);

  @override
  void visitImportDirective(ImportDirective node) {
    print('hi node=$node');

    // TODO
    if (false) {
      _nodes.add(_NodeWithMessage(
        node,
        'TODO',
      ));
    }
  }
}

class _NodeWithMessage {
  final AstNode node;
  final String message;

  _NodeWithMessage(this.node, this.message);
}
