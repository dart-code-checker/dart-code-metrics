// ignore_for_file: public_member_api_docs
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:code_checker/checker.dart';
import 'package:code_checker/rules.dart';

// Inspired by TSLint (https://palantir.github.io/tslint/rules/no-boolean-literal-compare/)

class NoBooleanLiteralCompareRule extends Rule {
  static const String ruleId = 'no-boolean-literal-compare';
  static const _documentationUrl = 'https://git.io/JJwmf';

  static const _failureCompareNullAwarePropertyWithTrue =
      'Comparison of null-conditional boolean with boolean literal may result in comparing null with boolean.';

  static const _correctionCompareNullAwarePropertyWithTrue =
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
          severity: readSeverity(config, Severity.style),
        );

  @override
  Iterable<Issue> check(ResolvedUnitResult source) {
    final _visitor = _Visitor();

    source.unit.visitChildren(_visitor);

    final issues = <Issue>[];

    for (final expression in _visitor.expressions) {
      if (_detectNullAwarePropertyCompareWithTrue(expression)) {
        issues.add(createIssue(
          this,
          nodeLocation(
            node: expression,
            source: source,
            withCommentOrMetadata: true,
          ),
          _failureCompareNullAwarePropertyWithTrue,
          Replacement(
            comment: _correctionCompareNullAwarePropertyWithTrue,
            replacement:
                _nullAwarePropertyCompareWithTrueCorrection(expression),
          ),
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
        nodeLocation(
          node: expression,
          source: source,
          withCommentOrMetadata: true,
        ),
        _failure,
        Replacement(
          comment: useDirect ? _useItDirectly : _negate,
          replacement: useDirect ? correction : '!$correction',
        ),
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
