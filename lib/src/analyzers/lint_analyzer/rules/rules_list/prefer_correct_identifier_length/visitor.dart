part of 'prefer_correct_identifier_length.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final _variableDeclarationNode = <VariableDeclaration>[];
  final CorrectIdentifierLengthValidator validator;

  _Visitor(this.validator);

  Iterable<VariableDeclaration> get nodes => _variableDeclarationNode;

  @override
  void visitVariableDeclaration(VariableDeclaration node) {
    super.visitVariableDeclaration(node);

    if (!validator.isValid<VariableDeclaration>(node)) {
      _variableDeclarationNode.add(node);
    }
  }
}
