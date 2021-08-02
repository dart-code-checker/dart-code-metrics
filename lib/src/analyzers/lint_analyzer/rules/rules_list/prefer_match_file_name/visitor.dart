part of 'prefer_match_file_name.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final _declarations = <SimpleIdentifier>[];

  Iterable<SimpleIdentifier> get declaration => _declarations..sort(_compareByPrivateType);

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    super.visitClassDeclaration(node);

    _declarations.add(node.name);
  }

  int _compareByPrivateType(SimpleIdentifier a, SimpleIdentifier b) {
    final isAPrivate = Identifier.isPrivateName(a.name);
    final isBPrivate = Identifier.isPrivateName(b.name);
    if (!isAPrivate && isBPrivate) {
      return -1;
    } else if (isAPrivate && !isBPrivate) {
      return 1;
    }

    return a.offset.compareTo(b.offset);
  }
}
