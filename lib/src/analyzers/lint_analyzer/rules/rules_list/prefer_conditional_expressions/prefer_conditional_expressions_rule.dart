// ignore_for_file: public_member_api_docs

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';

import '../../../../../utils/node_utils.dart';
import '../../../lint_utils.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/issue.dart';
import '../../../models/replacement.dart';
import '../../../models/severity.dart';
import '../../models/common_rule.dart';
import '../../rule_utils.dart';

part 'visitor.dart';

// Inspired by TSLint (https://palantir.github.io/tslint/rules/prefer-conditional-expression/)

class PreferConditionalExpressionsRule extends CommonRule {
  static const String ruleId = 'prefer-conditional-expressions';

  static const _warningMessage = 'Prefer conditional expression.';
  static const _correctionMessage = 'Convert to conditional expression.';

  PreferConditionalExpressionsRule([Map<String, Object> config = const {}])
      : super(
          id: ruleId,
          severity: readSeverity(config, Severity.style),
          excludes: readExcludes(config),
        );

  @override
  Iterable<Issue> check(InternalResolvedUnitResult source) {
    final _visitor = _Visitor();

    source.unit.visitChildren(_visitor);

    return _visitor.statementsInfo
        .map(
          (info) => createIssue(
            rule: this,
            location: nodeLocation(
              node: info.statement,
              source: source,
              withCommentOrMetadata: true,
            ),
            message: _warningMessage,
            replacement: _createReplacement(info),
          ),
        )
        .toList(growable: false);
  }

  Replacement? _createReplacement(_StatementInfo info) {
    final correction = _createCorrection(info);

    return correction == null
        ? null
        : Replacement(comment: _correctionMessage, replacement: correction);
  }

  String? _createCorrection(_StatementInfo info) {
    final thenStatement = info.unwrappedThenStatement;
    final elseStatement = info.unwrappedElseStatement;

    final condition = info.statement.condition;

    if (thenStatement is AssignmentExpression &&
        elseStatement is AssignmentExpression) {
      final target = thenStatement.leftHandSide;
      final firstExpression = thenStatement.rightHandSide;
      final secondExpression = elseStatement.rightHandSide;

      final thenStatementOperator = thenStatement.operator.type;
      final elseStatementOperator = elseStatement.operator.type;

      return _isAssignmentOperatorNotEq(thenStatementOperator) &&
              _isAssignmentOperatorNotEq(elseStatementOperator)
          ? '$condition ? ${thenStatement.leftHandSide} ${thenStatementOperator.stringValue} $firstExpression : ${thenStatement.leftHandSide} ${elseStatementOperator.stringValue} $secondExpression;'
          : '$target = $condition ? $firstExpression : $secondExpression;';
    }

    if (thenStatement is ReturnStatement && elseStatement is ReturnStatement) {
      final firstExpression = thenStatement.expression;
      final secondExpression = elseStatement.expression;

      return 'return $condition ? $firstExpression : $secondExpression;';
    }

    return null;
  }

  bool _isAssignmentOperatorNotEq(TokenType token) =>
      token.isAssignmentOperator && token != TokenType.EQ;
}
