part of 'prefer_immediate_return_rule.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final _issues = <_IssueDetails>[];

  Iterable<_IssueDetails> get issues => _issues;

  @override
  void visitBlockFunctionBody(BlockFunctionBody node) {
    super.visitBlockFunctionBody(node);

    if (node.block.statements.length < 2) {
      return;
    }

    final variableDeclarationStatement =
        node.block.statements[node.block.statements.length - 2];
    final returnStatement = node.block.statements.last;
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
    if (returnIdentifier.name != lastDeclaredVariable.name.name) {
      return;
    }

    _issues.add(_IssueDetails(
      lastDeclaredVariable.initializer,
      returnStatement,
    ));
  }
}

class _IssueDetails {
  const _IssueDetails(
    this.variableDeclarationInitializer,
    this.returnStatement,
  );

  final Expression? variableDeclarationInitializer;
  final ReturnStatement returnStatement;
}
