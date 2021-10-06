part of 'prefer_correct_identifier_length.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final _variableDeclarationNode = <VariableDeclaration>[];

  Iterable<VariableDeclaration> get node => _variableDeclarationNode;

  @override
  void visitVariableDeclaration(VariableDeclaration node) {
    super.visitVariableDeclaration(node);

    _variableDeclarationNode.add(node);
  }
}
