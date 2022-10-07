part of 'prefer_match_file_name_rule.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final _declarations = <_TokeInfo>[];

  Iterable<_TokeInfo> get declaration =>
      _declarations..sort(_compareByPrivateType);

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    super.visitClassDeclaration(node);

    _declarations.add(_TokeInfo(node.name, node));
  }

  @override
  void visitExtensionDeclaration(ExtensionDeclaration node) {
    super.visitExtensionDeclaration(node);

    final name = node.name;
    if (name != null) {
      _declarations.add(_TokeInfo(name, node));
    }
  }

  @override
  void visitMixinDeclaration(MixinDeclaration node) {
    super.visitMixinDeclaration(node);

    _declarations.add(_TokeInfo(node.name, node));
  }

  @override
  void visitEnumDeclaration(EnumDeclaration node) {
    super.visitEnumDeclaration(node);

    _declarations.add(_TokeInfo(node.name, node));
  }

  int _compareByPrivateType(_TokeInfo a, _TokeInfo b) {
    final isAPrivate = Identifier.isPrivateName(a.token.lexeme);
    final isBPrivate = Identifier.isPrivateName(b.token.lexeme);
    if (!isAPrivate && isBPrivate) {
      return -1;
    } else if (isAPrivate && !isBPrivate) {
      return 1;
    }

    return a.token.offset.compareTo(b.token.offset);
  }
}

class _TokeInfo {
  final Token token;
  final AstNode parent;

  const _TokeInfo(this.token, this.parent);
}
