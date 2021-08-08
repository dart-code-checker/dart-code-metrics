part of 'prefer_correct_identifier_length.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final _declarations = <VariableDeclaration>[];

  Iterable<VariableDeclaration> get declaration => _declarations;

  @override
  void visitVariableDeclaration(VariableDeclaration node) {
    super.visitVariableDeclaration(node);

    _declarations.add(node);
  }
}
