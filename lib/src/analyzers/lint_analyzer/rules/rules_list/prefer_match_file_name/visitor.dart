part of 'prefer_match_file_name.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  /// Collect all class declarations in file
  final _declarations = <SimpleIdentifier>[];

  Iterable<SimpleIdentifier> get declaration =>
      _declarations..sort((a, b) => a.offset.compareTo(b.offset));

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    super.visitClassDeclaration(node);
    _declarations.add(node.name);
  }
}
