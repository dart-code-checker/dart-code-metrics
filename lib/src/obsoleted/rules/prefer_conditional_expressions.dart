// ignore_for_file: public_member_api_docs
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:code_checker/checker.dart';
import 'package:code_checker/rules.dart';
import 'package:meta/meta.dart';

// Inspired by TSLint (https://palantir.github.io/tslint/rules/prefer-conditional-expression/)

class PreferConditionalExpressions extends Rule {
  static const String ruleId = 'prefer-conditional-expressions';
  static const _documentationUrl = 'https://git.io/JJwms';

  static const _warningMessage = 'Prefer conditional expression';
  static const _correctionMessage = 'Convert to conditional expression';

  PreferConditionalExpressions({Map<String, Object> config = const {}})
      : super(
          id: ruleId,
          documentation: Uri.parse(_documentationUrl),
          severity: readSeverity(config, Severity.style),
        );

  @override
  Iterable<Issue> check(ResolvedUnitResult source) {
    final _visitor = _Visitor();

    source.unit.visitChildren(_visitor);

    return _visitor.statementsInfo
        .map(
          (info) => createIssue(
            this,
            nodeLocation(
              node: info.statement,
              source: source,
              withCommentOrMetadata: true,
            ),
            _warningMessage,
            Replacement(
              comment: _correctionMessage,
              replacement: _createCorrection(info),
            ),
          ),
        )
        .toList(growable: false);
  }

  String _createCorrection(_StatementInfo info) {
    final thenStatement = info.unwrappedThenStatement;
    final elseStatement = info.unwrappedElseStatement;

    final condition = info.statement.condition;

    if (thenStatement is AssignmentExpression &&
        elseStatement is AssignmentExpression) {
      final target = thenStatement.leftHandSide;
      final firstExpression = thenStatement.rightHandSide;
      final secondExpression = elseStatement.rightHandSide;

      return '$target = $condition ? $firstExpression : $secondExpression;';
    }

    if (thenStatement is ReturnStatement && elseStatement is ReturnStatement) {
      final firstExpression = thenStatement.expression;
      final secondExpression = elseStatement.expression;

      return 'return $condition ? $firstExpression : $secondExpression;';
    }

    return null;
  }
}

class _Visitor extends RecursiveAstVisitor<void> {
  final _statementsInfo = <_StatementInfo>[];

  Iterable<_StatementInfo> get statementsInfo => _statementsInfo;

  @override
  void visitIfStatement(IfStatement node) {
    super.visitIfStatement(node);

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

  ReturnStatement _getReturnStatement(Statement statement) {
    if (statement is ReturnStatement) {
      return statement;
    }

    if (statement is Block && statement.statements.length == 1) {
      return _getReturnStatement(statement.statements.first);
    }

    return null;
  }
}

@immutable
class _StatementInfo {
  final IfStatement statement;
  final AstNode unwrappedThenStatement;
  final AstNode unwrappedElseStatement;

  const _StatementInfo({
    this.statement,
    this.unwrappedThenStatement,
    this.unwrappedElseStatement,
  });
}
