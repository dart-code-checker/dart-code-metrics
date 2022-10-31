// ignore_for_file: public_member_api_docs

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';

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

class PreferLastRule extends CommonRule {
  static const ruleId = 'prefer-last';
  static const _warningMessage =
      'Use last instead of accessing the last element by index.';
  static const _replaceComment = "Replace with 'last'.";

  PreferLastRule([Map<String, Object> config = const {}])
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

    return visitor.expressions
        .map((expression) => createIssue(
              rule: this,
              location: nodeLocation(node: expression, source: source),
              message: _warningMessage,
              replacement: _createReplacement(expression),
            ))
        .toList(growable: false);
  }

  Replacement _createReplacement(Expression expression) {
    String replacement;

    if (expression is MethodInvocation) {
      replacement =
          expression.isCascaded ? '..last' : '${expression.target ?? ''}.last';
    } else if (expression is IndexExpression) {
      replacement =
          expression.isCascaded ? '..last' : '${expression.target ?? ''}.last';
    } else {
      replacement = '.last';
    }

    return Replacement(
      comment: _replaceComment,
      replacement: replacement,
    );
  }
}
