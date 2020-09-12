import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/syntactic_entity.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:dart_code_metrics/src/models/code_issue.dart';
import 'package:dart_code_metrics/src/models/code_issue_severity.dart';
import 'package:meta/meta.dart';

import 'base_rule.dart';
import 'rule_utils.dart';

// Inspired by PVS-Studio (https://www.viva64.com/en/w/v6008/)

class PotentialNullDereference extends BaseRule {
  static const String ruleId = 'potential-null-dereference';
  static const _documentationUrl = 'https://git.io/JUG51';

  static const _warningMessage = 'can potentially be null';

  PotentialNullDereference({Map<String, Object> config = const {}})
      : super(
            id: ruleId,
            documentation: Uri.parse(_documentationUrl),
            severity:
                CodeIssueSeverity.fromJson(config['severity'] as String) ??
                    CodeIssueSeverity.warning);

  @override
  Iterable<CodeIssue> check(
    CompilationUnit unit,
    Uri sourceUrl,
    String sourceContent,
  ) {
    final _visitor = _Visitor();

    unit.visitChildren(_visitor);

    return _visitor.issues
        .map(
          (issue) => createIssue(
            this,
            '${issue.identifierName} $_warningMessage',
            null,
            null,
            sourceUrl,
            sourceContent,
            unit.lineInfo,
            issue.expression,
          ),
        )
        .toList(growable: false);
  }
}

class _Visitor extends RecursiveAstVisitor<void> {
  final _issues = <_Issue>[];

  Iterable<_Issue> get issues => _issues;

  @override
  void visitIfStatement(IfStatement node) {
    super.visitIfStatement(node);

    for (final child in node.childEntities) {
      if (child is BinaryExpression) {
        if (child.leftOperand.unParenthesized is! BinaryExpression &&
            child.rightOperand.unParenthesized is! BinaryExpression) {
          _visitSingleBinaryExpression(child, node.thenStatement);
        } else {
          _visitNestedBinaryExpression(child);
        }
      }
    }
  }

  void _visitSingleBinaryExpression(
    BinaryExpression node,
    Statement statement,
  ) {
    if (_isEqualNull(node.leftOperand, node.rightOperand, node.operator)) {
      final operand =
          node.leftOperand is Identifier ? node.leftOperand : node.rightOperand;
      final name = (operand as Identifier).name;

      _checkExpressions(statement.childEntities, name);
    }
  }

  bool _checkExpressions(Iterable<SyntacticEntity> children, String name) {
    var wasReassignedOrShadowed = false;

    for (final child in children) {
      if (child is AssignmentExpression &&
          child.leftHandSide is Identifier &&
          (child.leftHandSide as Identifier).name == name) {
        wasReassignedOrShadowed = true;
      } else if (child is VariableDeclaration && child.name.name == name) {
        wasReassignedOrShadowed = true;
      } else if (child is FormalParameter && child.identifier.name == name) {
        wasReassignedOrShadowed = true;
      } else if (child is Identifier && child.toString() == name) {
        _issues.add(_Issue(
          expression: child,
          identifierName: name,
        ));
      } else if (child is AstNode && !wasReassignedOrShadowed) {
        wasReassignedOrShadowed = _checkExpressions(child.childEntities, name);
      }
    }

    return wasReassignedOrShadowed;
  }

  void _visitNestedBinaryExpression(BinaryExpression node) {
    final token = _getTokenType(node);

    if (token != null) {
      final issue = _hasNullReference(node, token);

      if (issue != null) {
        _issues.add(issue);
      }
    }

    for (final child in node.childEntities) {
      if (child is BinaryExpression) {
        _visitNestedBinaryExpression(child);
      }
    }
  }

  TokenType _getTokenType(BinaryExpression node) {
    if (_isEqualNull(node.leftOperand, node.rightOperand, node.operator)) {
      return TokenType.AMPERSAND_AMPERSAND;
    }

    if (_isNotEqualNull(node.leftOperand, node.rightOperand, node.operator)) {
      return TokenType.BAR_BAR;
    }

    return null;
  }

  bool _isEqualNull(
    Expression leftOperand,
    Expression rightOperand,
    Token operator,
  ) =>
      operator.type == TokenType.EQ_EQ &&
      ((leftOperand is Identifier && rightOperand is NullLiteral) ||
          (rightOperand is Identifier && leftOperand is NullLiteral));

  bool _isNotEqualNull(
    Expression leftOperand,
    Expression rightOperand,
    Token operator,
  ) =>
      operator.type == TokenType.BANG_EQ &&
      ((leftOperand is Identifier && rightOperand is NullLiteral) ||
          (rightOperand is Identifier && leftOperand is NullLiteral));

  _Issue _hasNullReference(BinaryExpression node, TokenType tokenType) {
    final parent = node.parent;
    final operand =
        node.leftOperand is Identifier ? node.leftOperand : node.rightOperand;
    final name = (operand as Identifier).name;

    if (parent is BinaryExpression && parent.operator.type == tokenType) {
      final otherExpression = parent.leftOperand == node
          ? parent.rightOperand.unParenthesized
          : parent.leftOperand.unParenthesized;

      if (otherExpression is BinaryExpression ||
          otherExpression is MethodInvocation) {
        if (RegExp('$name\\.').hasMatch(otherExpression.toString())) {
          return _Issue(expression: parent, identifierName: name);
        }
      }
    }

    return null;
  }
}

@immutable
class _Issue {
  final Expression expression;
  final String identifierName;

  const _Issue({
    this.expression,
    this.identifierName,
  });
}
