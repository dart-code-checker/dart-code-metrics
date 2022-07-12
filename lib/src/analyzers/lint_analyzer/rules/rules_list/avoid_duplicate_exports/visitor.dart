part of 'avoid_duplicate_exports_rule.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final _exports = <String>{};

  final _nodes = <AstNode>[];

  Iterable<AstNode> get nodes => _nodes;

  @override
  void visitExportDirective(ExportDirective node) {
    super.visitExportDirective(node);

    final uri = node.uri.stringValue;
    if (uri == null) {
      return;
    }

    if (_exports.contains(uri)) {
      _nodes.add(node);
    }

    _exports.add(uri);
  }
}
