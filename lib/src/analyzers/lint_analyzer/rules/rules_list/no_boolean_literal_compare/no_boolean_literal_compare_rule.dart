// ignore_for_file: public_member_api_docs

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/type.dart';

import '../../../../../utils/dart_types_utils.dart';
import '../../../../../utils/node_utils.dart';
import '../../../lint_utils.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/issue.dart';
import '../../../models/replacement.dart';
import '../../../models/severity.dart';
import '../../models/common_rule.dart';
import '../../rule_utils.dart';

part 'visitor.dart';

// Inspired by TSLint (https://palantir.github.io/tslint/rules/no-boolean-literal-compare/)

class NoBooleanLiteralCompareRule extends CommonRule {
  static const String ruleId = 'no-boolean-literal-compare';

  static const _warning =
      'Comparing boolean values to boolean literals is unnecessary, as those expressions will result in booleans too. Just use the boolean values directly or negate them.';

  static const _useItDirectly =
      'This expression is unnecessarily compared to a boolean. Just use it directly.';
  static const _negate =
      'This expression is unnecessarily compared to a boolean. Just negate it.';

  NoBooleanLiteralCompareRule([Map<String, Object> config = const {}])
      : super(
          id: ruleId,
          severity: readSeverity(config, Severity.style),
          excludes: readExcludes(config),
          includes: readIncludes(config),
        );

  @override
  Iterable<Issue> check(InternalResolvedUnitResult source) {
    final visitor = _Visitor();

    source.unit.visitChildren(visitor);

    final issues = <Issue>[];

    for (final expression in visitor.expressions) {
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

      final type = expression.operator.type;
      final useDirect =
          (type == TokenType.EQ_EQ && booleanLiteralOperand == 'true') ||
              (type == TokenType.BANG_EQ && booleanLiteralOperand == 'false');

      issues.add(createIssue(
        rule: this,
        location: nodeLocation(node: expression, source: source),
        message: _warning,
        replacement: Replacement(
          comment: useDirect ? _useItDirectly : _negate,
          replacement: useDirect ? correction : '!$correction',
        ),
      ));
    }

    return issues;
  }
}
