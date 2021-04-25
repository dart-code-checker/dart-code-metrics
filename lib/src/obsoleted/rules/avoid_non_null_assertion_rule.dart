import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';

import '../../models/issue.dart';
import '../../models/severity.dart';
import '../../utils/node_utils.dart';
import '../../utils/rule_utils.dart';
import 'obsolete_rule.dart';

class AvoidNonNullAssertionRule extends ObsoleteRule {
  static const String ruleId = 'avoid-non-null-assertion';
  static const _documentationUrl = 'https://git.io/JO5Ju';

  static const _failure = 'Avoid using non null assertion.';

  AvoidNonNullAssertionRule({Map<String, Object> config = const {}})
      : super(
          id: ruleId,
          documentationUrl: Uri.parse(_documentationUrl),
          severity: readSeverity(config, Severity.warning),
          excludes: readExcludes(config),
        );

  @override
  Iterable<Issue> check(ResolvedUnitResult source) {
    final visitor = _Visitor();

    source.unit?.visitChildren(visitor);

    return visitor.expressions
        .map((expression) => createIssue(
              rule: this,
              location: nodeLocation(
                node: expression,
                source: source,
                withCommentOrMetadata: true,
              ),
              message: _failure,
            ))
        .toList(growable: false);
  }
}

class _Visitor extends RecursiveAstVisitor<void> {
  final _expressions = <Expression>[];

  Iterable<Expression> get expressions => _expressions;

  @override
  void visitPostfixExpression(PostfixExpression node) {
    super.visitPostfixExpression(node);

    if (node.operator.type == TokenType.BANG &&
        !_isMapIndexOperator(node.operand)) {
      _expressions.add(node);
    }
  }

  bool _isMapIndexOperator(Expression operand) {
    if (operand is IndexExpression) {
      final type = operand.target?.staticType;

      return type != null && type.isDartCoreMap;
    }

    return false;
  }
}
