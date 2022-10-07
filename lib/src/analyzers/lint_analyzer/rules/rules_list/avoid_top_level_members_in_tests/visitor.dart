part of 'avoid_top_level_members_in_tests_rule.dart';

class _Visitor extends GeneralizingAstVisitor<void> {
  final _declarations = <AstNode>[];

  Iterable<AstNode> get declarations => _declarations;

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    if (!Identifier.isPrivateName(node.name.lexeme)) {
      _declarations.add(node);
    }
  }

  @override
  void visitMixinDeclaration(MixinDeclaration node) {
    if (!Identifier.isPrivateName(node.name.lexeme)) {
      _declarations.add(node);
    }
  }

  @override
  void visitExtensionDeclaration(ExtensionDeclaration node) {
    final name = node.name?.lexeme;
    if (name != null && !Identifier.isPrivateName(name)) {
      _declarations.add(node);
    }
  }

  @override
  void visitEnumDeclaration(EnumDeclaration node) {
    if (!Identifier.isPrivateName(node.name.lexeme)) {
      _declarations.add(node);
    }
  }

  @override
  void visitTypeAlias(TypeAlias node) {
    if (!Identifier.isPrivateName(node.name.lexeme)) {
      _declarations.add(node);
    }
  }

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    final name = node.name.lexeme;
    if (isEntrypoint(name, node.metadata)) {
      return;
    }

    if (!Identifier.isPrivateName(name)) {
      _declarations.add(node);
    }
  }

  @override
  void visitTopLevelVariableDeclaration(TopLevelVariableDeclaration node) {
    final variables = node.variables.variables;

    if (variables.isNotEmpty &&
        !Identifier.isPrivateName(variables.first.name.lexeme)) {
      _declarations.add(variables.first);
    }
  }
}
