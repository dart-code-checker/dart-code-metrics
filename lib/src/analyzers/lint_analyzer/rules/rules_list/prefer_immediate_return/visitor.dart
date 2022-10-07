part of 'prefer_immediate_return_rule.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final _issues = <_IssueDetails>[];

  Iterable<_IssueDetails> get issues => _issues;

  @override
  void visitBlock(Block node) {
    super.visitBlock(node);

    final length = node.statements.length;
    if (length < 2) {
      return;
    }

    final variableDeclarationStatement = node.statements[length - 2];
    final returnStatement = node.statements.last;
    if (variableDeclarationStatement is! VariableDeclarationStatement ||
        returnStatement is! ReturnStatement) {
      return;
    }

    final returnIdentifier = returnStatement.expression;
    if (returnIdentifier is! Identifier) {
      return;
    }

    final lastDeclaredVariable =
        variableDeclarationStatement.variables.variables.last;
    if (returnIdentifier.name != lastDeclaredVariable.name.lexeme) {
      return;
    }

    _issues.add(_IssueDetails(
      lastDeclaredVariable,
      returnStatement,
    ));
  }
}

class _IssueDetails {
  const _IssueDetails(
    this.variableDeclaration,
    this.returnStatement,
  );

  final VariableDeclaration variableDeclaration;
  final ReturnStatement returnStatement;
}
