import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';

import '../../../../utils/node_utils.dart';
import '../../../models/issue.dart';
import '../../../models/replacement.dart';
import '../../../models/severity.dart';
import '../models/obsolete_rule.dart';
import '../rule_utils.dart';

// Inspired by TSLint (https://palantir.github.io/tslint/rules/no-boolean-literal-compare/)

class NoBooleanLiteralCompareRule extends ObsoleteRule {
  static const String ruleId = 'no-boolean-literal-compare';

  static const _failure =
      'Comparing boolean values to boolean literals is unnecessary, as those expressions will result in booleans too. Just use the boolean values directly or negate them.';

  static const _useItDirectly =
      'This expression is unnecessarily compared to a boolean. Just use it directly.';
  static const _negate =
      'This expression is unnecessarily compared to a boolean. Just negate it.';

  NoBooleanLiteralCompareRule({Map<String, Object> config = const {}})
      : super(
          id: ruleId,
          severity: readSeverity(config, Severity.style),
          excludes: readExcludes(config),
        );

  @override
  Iterable<Issue> check(ResolvedUnitResult source) {
    final _visitor = _Visitor();

    source.unit?.visitChildren(_visitor);

    final issues = <Issue>[];

    for (final expression in _visitor.expressions) {
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
        rule: this,
        location: nodeLocation(
          node: expression,
          source: source,
          withCommentOrMetadata: true,
        ),
        message: _failure,
        replacement: Replacement(
          comment: useDirect ? _useItDirectly : _negate,
          replacement: useDirect ? correction : '!$correction',
        ),
      ));
    }

    return issues;
  }
}

class _Visitor extends RecursiveAstVisitor<void> {
  static const _scannedTokenTypes = {TokenType.EQ_EQ, TokenType.BANG_EQ};

  final _expressions = <BinaryExpression>[];

  Iterable<BinaryExpression> get expressions => _expressions;

  @override
  void visitBinaryExpression(BinaryExpression node) {
    super.visitBinaryExpression(node);

    if (!_scannedTokenTypes.contains(node.operator.type)) {
      return;
    }

    if ((node.leftOperand is BooleanLiteral &&
            _isTypeBoolean(node.rightOperand.staticType)) ||
        (_isTypeBoolean(node.leftOperand.staticType) &&
            node.rightOperand is BooleanLiteral)) {
      _expressions.add(node);
    }
  }

  bool _isTypeBoolean(DartType? type) =>
      type != null &&
      type.isDartCoreBool &&
      type.nullabilitySuffix == NullabilitySuffix.none;
}
