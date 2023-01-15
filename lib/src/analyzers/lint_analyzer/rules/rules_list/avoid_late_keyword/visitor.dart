part of 'avoid_late_keyword_rule.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final bool allowInitialized;
  final Iterable<String> ignoredTypes;

  final _declarations = <AstNode>[];

  Iterable<AstNode> get declarations => _declarations;

  // ignore: avoid_positional_boolean_parameters
  _Visitor(this.allowInitialized, this.ignoredTypes);

  @override
  void visitVariableDeclaration(VariableDeclaration node) {
    super.visitVariableDeclaration(node);

    if (node.isLate && node.parent != null) {
      final parent = node.parent;

      if (!_allowsInitialized(node) && !_hasIgnoredType(node)) {
        _declarations.add(parent ?? node);
      }
    }
  }

  bool _allowsInitialized(VariableDeclaration node) =>
      allowInitialized && node.initializer != null;

  bool _hasIgnoredType(VariableDeclaration node) => ignoredTypes.contains(
        // ignore: deprecated_member_use
        node.declaredElement2?.type.getDisplayString(withNullability: false),
      );
}
