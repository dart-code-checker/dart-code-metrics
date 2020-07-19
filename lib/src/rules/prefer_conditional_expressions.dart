import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:dart_code_metrics/src/models/code_issue.dart';
import 'package:dart_code_metrics/src/models/code_issue_severity.dart';

import 'base_rule.dart';
import 'rule_utils.dart';

// Inspired by TSLint (https://palantir.github.io/tslint/rules/prefer-conditional-expression/)

class PreferConditionalExpressions extends BaseRule {
  static const _warningMessage = 'Prefer conditional expression';

  const PreferConditionalExpressions()
      : super(
          id: 'prefer-conditional-expressions',
          severity: CodeIssueSeverity.style,
        );

  @override
  Iterable<CodeIssue> check(
    CompilationUnit unit,
    Uri sourceUrl,
    String sourceContent,
  ) {
    final _visitor = _Visitor();

    unit.visitChildren(_visitor);

    return _visitor.statements
        .map((statement) => createIssue(this, _warningMessage, null, null,
            sourceUrl, sourceContent, unit.lineInfo, statement))
        .toList(growable: false);
  }
}

class _Visitor extends RecursiveAstVisitor<void> {
  final _statements = <IfStatement>[];

  Iterable<IfStatement> get statements => _statements;

  @override
  void visitIfStatement(IfStatement node) {
    super.visitIfStatement(node);

    if (node.elseStatement != null && node.elseStatement is! IfStatement) {
      if (_hasAssignment(node) || _hasReturn(node)) {
        _statements.add(node);
      }
    }
  }

  bool _hasAssignment(IfStatement statement) {
    final thenAssignment = _getAssignmentExpression(statement.thenStatement);
    final elseAssignment = _getAssignmentExpression(statement.elseStatement);

    return thenAssignment != null &&
        elseAssignment != null &&
        _checkAssignmentExpression(thenAssignment, elseAssignment);
  }

  AssignmentExpression _getAssignmentExpression(Statement statement) {
    if (statement is ExpressionStatement &&
        statement.expression is AssignmentExpression) {
      return statement.expression as AssignmentExpression;
    }

    if (statement is Block && statement.statements.length == 1) {
      final innerStatement = statement.statements.single;

      if (innerStatement is ExpressionStatement &&
          innerStatement.expression is AssignmentExpression) {
        return innerStatement.expression as AssignmentExpression;
      }
    }

    return null;
  }

  bool _checkAssignmentExpression(
    AssignmentExpression thenAssignment,
    AssignmentExpression elseAssignment,
  ) =>
      thenAssignment.leftHandSide is Identifier &&
      elseAssignment.leftHandSide is Identifier &&
      (thenAssignment.leftHandSide as Identifier).name ==
          (elseAssignment.leftHandSide as Identifier).name;

  bool _hasReturn(IfStatement statement) {
    final thenReturn = _getReturnStatement(statement.thenStatement);
    final elseReturn = _getReturnStatement(statement.elseStatement);

    return thenReturn != null && elseReturn != null;
  }

  ReturnStatement _getReturnStatement(Statement statement) {
    if (statement is ReturnStatement) {
      return statement;
    }

    if (statement is Block && statement.statements.length == 1) {
      final innerStatement = statement.statements.single;

      if (innerStatement is ReturnStatement) {
        return innerStatement;
      }
    }

    return null;
  }
}
