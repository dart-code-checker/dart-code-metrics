// ignore_for_file: deprecated_member_use

part of 'avoid_top_level_members_in_tests_rule.dart';

class _Visitor extends GeneralizingAstVisitor<void> {
  final _declarations = <AstNode>[];

  Iterable<AstNode> get declarations => _declarations;

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    if (!Identifier.isPrivateName(node.name.name)) {
      _declarations.add(node);
    }
  }

  @override
  void visitMixinDeclaration(MixinDeclaration node) {
    if (!Identifier.isPrivateName(node.name.name)) {
      _declarations.add(node);
    }
  }

  @override
  void visitExtensionDeclaration(ExtensionDeclaration node) {
    final name = node.name?.name;
    if (name != null && !Identifier.isPrivateName(name)) {
      _declarations.add(node);
    }
  }

  @override
  void visitEnumDeclaration(EnumDeclaration node) {
    if (!Identifier.isPrivateName(node.name.name)) {
      _declarations.add(node);
    }
  }

  @override
  void visitTypeAlias(TypeAlias node) {
    if (!Identifier.isPrivateName(node.name.name)) {
      _declarations.add(node);
    }
  }

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    final name = node.name.name;
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
        !Identifier.isPrivateName(variables.first.name.name)) {
      _declarations.add(variables.first);
    }
  }
}
