part of 'prefer_match_file_name.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  /// Collect all class declarations in file
  final _declarations = <ClassDeclaration>[];

  Iterable<ClassDeclaration> get declaration =>
      _declarations..sort((a, b) => a.name.offset.compareTo(b.name.offset));

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    _declarations.add(node);
  }
}


