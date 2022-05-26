part of 'avoid_banned_imports_rule.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final List<_AvoidBannedImportsConfigEntry> _activeEntries;

  final _nodes = <_NodeWithMessage>[];

  Iterable<_NodeWithMessage> get nodes => _nodes;

  _Visitor(this._activeEntries);

  @override
  void visitImportDirective(ImportDirective node) {
    // print('hi node=$node uri=${node.uri} uri.stringValue=${node.uri.stringValue}');

    final uri = node.uri.stringValue;
    if (uri == null) {
      return;
    }

    for (final entry in _activeEntries) {
      if (entry.deny.any((deny) => _globMatch(pattern: deny, data: uri))) {
        _nodes.add(_NodeWithMessage(
          node,
          'Avoid banned imports (${entry.message})',
        ));
      }
    }
  }
}

class _NodeWithMessage {
  final AstNode node;
  final String message;

  _NodeWithMessage(this.node, this.message);
}

bool _globMatch({required String pattern, required String data}) => TODO;
