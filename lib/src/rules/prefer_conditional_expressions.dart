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
      if (_hasBothAssignment(node) || _hasBothReturn(node)) {
        _statements.add(node);
      }
    }
  }

  bool _hasBothAssignment(IfStatement statement) {
    final thenAssignment = _getAssignmentExpression(statement.thenStatement);
    final elseAssignment = _getAssignmentExpression(statement.elseStatement);

    return thenAssignment != null &&
        elseAssignment != null &&
        _haveEqualNames(thenAssignment, elseAssignment);
  }

  AssignmentExpression _getAssignmentExpression(Statement statement) {
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

  bool _hasBothReturn(IfStatement statement) =>
      _isReturnStatement(statement.thenStatement) &&
      _isReturnStatement(statement.elseStatement);

  bool _isReturnStatement(Statement statement) =>
      statement is ReturnStatement ||
      statement is Block &&
          statement.statements.length == 1 &&
          statement.statements.first is ReturnStatement;
}
