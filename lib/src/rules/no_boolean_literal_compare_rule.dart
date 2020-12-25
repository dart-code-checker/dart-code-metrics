import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';

import '../models/code_issue.dart';
import '../models/code_issue_severity.dart';
import '../models/source.dart';
import 'base_rule.dart';
import 'rule_utils.dart';

// Inspired by TSLint (https://palantir.github.io/tslint/rules/no-boolean-literal-compare/)

class NoBooleanLiteralCompareRule extends BaseRule {
  static const String ruleId = 'no-boolean-literal-compare';
  static const _documentationUrl = 'https://git.io/JJwmf';

  static const _failureCompareNullAwarePropertyWithTrue =
      'Comparison of null-conditional boolean with boolean literal may result in comparing null with boolean.';

  static const _correctionComprareNullAwarePropertyWithTrue =
      'Prefer using null-coalescing operator with false literal on right hand side.';

  static const _failure =
      'Comparing boolean values to boolean literals is unnecessary, as those expressions will result in booleans too. Just use the boolean values directly or negate them.';

  static const _useItDirectly =
      'This expression is unnecessarily compared to a boolean. Just use it directly.';
  static const _negate =
      'This expression is unnecessarily compared to a boolean. Just negate it.';

  NoBooleanLiteralCompareRule({Map<String, Object> config = const {}})
      : super(
          id: ruleId,
          documentation: Uri.parse(_documentationUrl),
          severity: CodeIssueSeverity.fromJson(config['severity'] as String) ??
              CodeIssueSeverity.style,
        );

  @override
  Iterable<CodeIssue> check(Source source) {
    final _visitor = _Visitor();

    source.compilationUnit.visitChildren(_visitor);

    final issues = <CodeIssue>[];

    for (final expression in _visitor.expressions) {
      if (_detectNullAwarePropertyCompareWithTrue(expression)) {
        issues.add(createIssue(
          this,
          _failureCompareNullAwarePropertyWithTrue,
          _nullAwarePropertyCompareWithTrueCorrection(expression),
          _correctionComprareNullAwarePropertyWithTrue,
          source.url,
          source.content,
          source.compilationUnit.lineInfo,
          expression,
        ));

        continue;
      }

      final leftOperandBooleanLiteral =
          expression.leftOperand is BooleanLiteral;

      final booleanLiteralOperand = (leftOperandBooleanLiteral
              ? expression.leftOperand
              : expression.rightOperand)
          .toString();

      final correction = (leftOperandBooleanLiteral
              ? expression.rightOperand
              : expression.leftOperand)
          .toString();

      final useDirect = (expression.operator.type == TokenType.EQ_EQ &&
              booleanLiteralOperand == 'true') ||
          (expression.operator.type == TokenType.BANG_EQ &&
              booleanLiteralOperand == 'false');

      issues.add(createIssue(
        this,
        _failure,
        useDirect ? correction : '!$correction',
        useDirect ? _useItDirectly : _negate,
        source.url,
        source.content,
        source.compilationUnit.lineInfo,
        expression,
      ));
    }

    return issues;
  }
}

class _Visitor extends RecursiveAstVisitor<void> {
  static const _scannedTokenTypes = [TokenType.EQ_EQ, TokenType.BANG_EQ];

  final _expressions = <BinaryExpression>[];

  Iterable<BinaryExpression> get expressions => _expressions;

  @override
  void visitBinaryExpression(BinaryExpression node) {
    super.visitBinaryExpression(node);

    if (_scannedTokenTypes.any((element) => element == node.operator.type) &&
        (node.leftOperand is BooleanLiteral ||
            node.rightOperand is BooleanLiteral)) {
      _expressions.add(node);
    }
  }
}

bool _detectNullAwarePropertyCompareWithTrue(BinaryExpression expression) =>
    _leftNullAwareOperandCompareWithTrue(expression) ||
    _rightNullAwareOperandCompareWithTrue(expression);

String _nullAwarePropertyCompareWithTrueCorrection(
  BinaryExpression expression,
) {
  if (_leftNullAwareOperandCompareWithTrue(expression)) {
    return '${expression.leftOperand} ?? false';
  } else if (_rightNullAwareOperandCompareWithTrue(expression)) {
    return '${expression.rightOperand} ?? false';
  }

  return expression.toString();
}

bool _leftNullAwareOperandCompareWithTrue(BinaryExpression expression) {
  final leftOperand = expression.leftOperand;
  final rightOperand = expression.rightOperand;

  return leftOperand is PropertyAccess &&
      leftOperand.isNullAware &&
      expression.operator.type == TokenType.EQ_EQ &&
      rightOperand is BooleanLiteral &&
      rightOperand.value;
}

bool _rightNullAwareOperandCompareWithTrue(BinaryExpression expression) {
  final leftOperand = expression.leftOperand;
  final rightOperand = expression.rightOperand;

  return rightOperand is PropertyAccess &&
      rightOperand.isNullAware &&
      expression.operator.type == TokenType.EQ_EQ &&
      leftOperand is BooleanLiteral &&
      leftOperand.value;
}
