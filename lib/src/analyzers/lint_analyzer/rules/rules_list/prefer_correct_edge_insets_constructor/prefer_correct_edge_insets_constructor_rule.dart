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
import '../../models/flutter_rule.dart';
import '../../rule_utils.dart';

part 'visitor.dart';

class PreferCorrectEdgeInsetsConstructorRule extends FlutterRule {
  static const ruleId = 'prefer-correct-edge-insets-constructor';
  static const _issueMessage = 'Prefer using correct EdgeInsets constructor.';

  PreferCorrectEdgeInsetsConstructorRule([
    Map<String, Object> config = const {},
  ]) : super(
          id: ruleId,
          severity: readSeverity(config, Severity.style),
          excludes: readExcludes(config),
        );

  @override
  Iterable<Issue> check(InternalResolvedUnitResult source) {
    final visitor = _Visitor();
    source.unit.visitChildren(visitor);

    return visitor.expressions.entries
        .map((expression) => createIssue(
              rule: this,
              location: nodeLocation(
                node: expression.key,
                source: source,
                withCommentOrMetadata: true,
              ),
              message: _issueMessage,
              replacement: _createReplacement(expression.value),
            ))
        .toList(growable: false);
  }

  Replacement? _createReplacement(String expression) => Replacement(
        comment: 'Prefer use $expression',
        replacement: expression,
      );
}
