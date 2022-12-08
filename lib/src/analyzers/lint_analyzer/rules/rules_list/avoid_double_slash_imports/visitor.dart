part of 'avoid_double_slash_imports_rule.dart';

class _Visitor extends GeneralizingAstVisitor<void> {
  final _nodes = <UriBasedDirective>[];

  Iterable<UriBasedDirective> get nodes => _nodes;

  _Visitor();

  @override
  void visitUriBasedDirective(UriBasedDirective node) {
    final uri = node.uri.stringValue;
    if (uri == null) {
      return;
    }

    if (uri.contains('//') || (uri.contains(r'\\') && !uri.startsWith(r'\\'))) {
      _nodes.add(node);
    }
  }
}
