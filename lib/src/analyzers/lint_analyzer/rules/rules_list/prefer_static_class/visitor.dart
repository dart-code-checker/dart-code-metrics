part of 'prefer_static_class_rule.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  _Visitor({
    required bool ignorePrivate,
    required Iterable<String> ignoreNames,
    required Iterable<String> ignoreAnnotations,
  })  : _ignorePrivate = ignorePrivate,
        _ignoreNames = ignoreNames.map(RegExp.new),
        _ignoreAnnotations = ignoreAnnotations;

  final bool _ignorePrivate;
  final Iterable<RegExp> _ignoreNames;
  final Iterable<String> _ignoreAnnotations;

  final _declarations = <AstNode>[];

  Iterable<AstNode> get declarations => _declarations;

  @override
  void visitTopLevelVariableDeclaration(TopLevelVariableDeclaration node) {
    super.visitTopLevelVariableDeclaration(node);

    if (!_hasIgnoredAnnotation(node) &&
        !node.variables.variables
            .every((variable) => _shouldIgnoreName(variable.name.lexeme))) {
      _declarations.add(node);
    }
  }

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    super.visitFunctionDeclaration(node);
    final nodeName = node.name.lexeme;
    if (node.parent is CompilationUnit &&
        !_hasIgnoredAnnotation(node) &&
        !_shouldIgnoreName(nodeName) &&
        !isEntrypoint(nodeName, node.metadata)) {
      _declarations.add(node);
    }
  }

  bool _shouldIgnoreName(String name) =>
      (_ignorePrivate && Identifier.isPrivateName(name)) ||
      _ignoreNames.any((element) => element.hasMatch(name));

  bool _hasIgnoredAnnotation(Declaration node) => node.metadata.any(
        (node) =>
            _ignoreAnnotations.contains(node.name.name) &&
            node.atSign.type == TokenType.AT,
      );
}
