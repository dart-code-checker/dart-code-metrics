// ignore_for_file: public_member_api_docs

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';

import '../../../../../utils/node_utils.dart';
import '../../../lint_utils.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/issue.dart';
import '../../../models/replacement.dart';
import '../../../models/severity.dart';
import '../../models/flutter_rule.dart';
import '../../rule_utils.dart';

part 'visitor.dart';

class AvoidBorderAllRule extends FlutterRule {
  static const ruleId = 'avoid-border-all';
  static const _issueMessage =
      'Prefer using const constructor Border.fromBorderSide.';
  static const _replaceComment = 'Replace with const Border.fromBorderSide.';

  AvoidBorderAllRule([Map<String, Object> config = const {}])
      : super(
          id: ruleId,
          severity: readSeverity(config, Severity.performance),
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
              message: _issueMessage,
              replacement: _createReplacement(expression),
            ))
        .toList(growable: false);
  }

  Replacement? _createReplacement(InstanceCreationExpression expression) {
    final value = expression.argumentList.arguments
        .map((arg) => '$arg')
        .join(', ')
        .trim();

    return Replacement(
      comment: _replaceComment,
      replacement: 'const Border.fromBorderSide(BorderSide($value))',
    );
  }
}
