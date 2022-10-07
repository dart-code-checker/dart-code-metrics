part of 'prefer_correct_identifier_length_rule.dart';

class _Visitor extends ScopeVisitor {
  final _declarationNodes = <Token>[];
  final _Validator validator;

  _Visitor(this.validator);

  Iterable<Token> get nodes => _declarationNodes;

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    super.visitMethodDeclaration(node);

    if ((node.isGetter || node.isSetter) &&
        !validator.isValid(node.name.lexeme)) {
      _declarationNodes.add(node.name);
    }
  }

  @override
  void visitEnumDeclaration(EnumDeclaration node) {
    super.visitEnumDeclaration(node);

    for (final node in node.constants) {
      if (!validator.isValid(node.name.lexeme)) {
        _declarationNodes.add(node.name);
      }
    }
  }

  @override
  void visitVariableDeclaration(VariableDeclaration node) {
    super.visitVariableDeclaration(node);

    if (!validator.isValid(node.name.lexeme)) {
      _declarationNodes.add(node.name);
    }
  }
}
