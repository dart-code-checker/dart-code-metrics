import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/type.dart';

import '../../../../../utils/node_utils.dart';
import '../../../lint_utils.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/issue.dart';
import '../../../models/replacement.dart';
import '../../../models/severity.dart';
import '../../models/common_rule.dart';
import '../../models/rule_documentation.dart';
import '../../rule_utils.dart';

part 'visitor.dart';

class PreferFirstRule extends CommonRule {
  static const ruleId = 'prefer-first';
  static const _warningMessage =
      'Use first instead of access to element at zero index.';
  static const _replaceComment = "Replace with 'first'.";

  PreferFirstRule([Map<String, Object> config = const {}])
      : super(
          id: ruleId,
          documentation: const RuleDocumentation(
            name: 'Prefer first',
            brief: 'Use `first` to gets the first element',
          ),
          severity: readSeverity(config, Severity.style),
          excludes: readExcludes(config),
        );

  @override
  Iterable<Issue> check(InternalResolvedUnitResult source) {
    final visitor = _Visitor();
    source.unit.visitChildren(visitor);

    return visitor.expressions
        .map((expression) => createIssue(
              rule: this,
              location: nodeLocation(
                node: expression,
                source: source,
                withCommentOrMetadata: true,
              ),
              message: _warningMessage,
              replacement: _createReplacement(expression),
            ))
        .toList(growable: false);
  }

  Replacement _createReplacement(Expression expression) {
    String replacement;

    if (expression is MethodInvocation) {
      replacement = expression.isCascaded
          ? '..first'
          : '${expression.target ?? ''}.first';
    } else if (expression is IndexExpression) {
      replacement = expression.isCascaded
          ? '..first'
          : '${expression.target ?? ''}.first';
    } else {
      replacement = '.first';
    }

    return Replacement(
      comment: _replaceComment,
      replacement: replacement,
    );
  }
}
