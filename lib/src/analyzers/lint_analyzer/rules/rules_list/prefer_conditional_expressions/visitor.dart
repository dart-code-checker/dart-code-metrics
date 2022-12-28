part of 'prefer_conditional_expressions_rule.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final _statementsInfo = <_StatementInfo>[];

  final bool _ignoreNested;

  Iterable<_StatementInfo> get statementsInfo => _statementsInfo;

  // ignore: avoid_positional_boolean_parameters
  _Visitor(this._ignoreNested);

  @override
  void visitIfStatement(IfStatement node) {
    super.visitIfStatement(node);

    if (_ignoreNested) {
      final visitor = _ConditionalsVisitor();
      node.visitChildren(visitor);

      if (visitor.hasInnerConditionals) {
        return;
      }
    }

    if (node.parent is! IfStatement &&
        node.elseStatement != null &&
        node.elseStatement is! IfStatement) {
      _checkBothAssignment(node);
      _checkBothReturn(node);
    }
  }

  void _checkBothAssignment(IfStatement statement) {
    final thenAssignment = _getAssignmentExpression(statement.thenStatement);
    final elseAssignment = _getAssignmentExpression(statement.elseStatement);

    if (thenAssignment != null &&
        elseAssignment != null &&
        _haveEqualNames(thenAssignment, elseAssignment)) {
      _statementsInfo.add(_StatementInfo(
        statement: statement,
        unwrappedThenStatement: thenAssignment,
        unwrappedElseStatement: elseAssignment,
      ));
    }
  }

  AssignmentExpression? _getAssignmentExpression(Statement? statement) {
    if (statement is ExpressionStatement &&
        statement.expression is AssignmentExpression) {
      return statement.expression as AssignmentExpression;
    }

    if (statement is Block && statement.statements.length == 1) {
      return _getAssignmentExpression(statement.statements.first);
    }

    return null;
  }

  bool _haveEqualNames(
    AssignmentExpression thenAssignment,
    AssignmentExpression elseAssignment,
  ) =>
      thenAssignment.leftHandSide is Identifier &&
      elseAssignment.leftHandSide is Identifier &&
      (thenAssignment.leftHandSide as Identifier).name ==
          (elseAssignment.leftHandSide as Identifier).name;

  void _checkBothReturn(IfStatement statement) {
    final thenReturn = _getReturnStatement(statement.thenStatement);
    final elseReturn = _getReturnStatement(statement.elseStatement);

    if (thenReturn != null && elseReturn != null) {
      _statementsInfo.add(_StatementInfo(
        statement: statement,
        unwrappedThenStatement: thenReturn,
        unwrappedElseStatement: elseReturn,
      ));
    }
  }

  ReturnStatement? _getReturnStatement(Statement? statement) {
    if (statement is ReturnStatement) {
      return statement;
    }

    if (statement is Block && statement.statements.length == 1) {
      return _getReturnStatement(statement.statements.first);
    }

    return null;
  }
}

class _ConditionalsVisitor extends RecursiveAstVisitor<void> {
  bool hasInnerConditionals = false;

  @override
  void visitConditionalExpression(ConditionalExpression node) {
    hasInnerConditionals = true;

    super.visitConditionalExpression(node);
  }
}

class _StatementInfo {
  final IfStatement statement;
  final AstNode unwrappedThenStatement;
  final AstNode unwrappedElseStatement;

  const _StatementInfo({
    required this.statement,
    required this.unwrappedThenStatement,
    required this.unwrappedElseStatement,
  });
}
