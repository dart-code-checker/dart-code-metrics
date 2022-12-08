// ignore_for_file: public_member_api_docs

import 'package:analyzer/dart/ast/ast.dart';
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

class AvoidUnnecessaryConditionalsRule extends CommonRule {
  static const String ruleId = 'avoid-unnecessary-conditionals';

  static const _warning = 'Avoid unnecessary conditional expressions.';
  static const _correctionMessage =
      'Remove unnecessary conditional expression.';

  AvoidUnnecessaryConditionalsRule([Map<String, Object> config = const {}])
      : super(
          id: ruleId,
          severity: readSeverity(config, Severity.warning),
          excludes: readExcludes(config),
          includes: readIncludes(config),
        );

  @override
  Iterable<Issue> check(InternalResolvedUnitResult source) {
    final visitor = _Visitor();

    source.unit.visitChildren(visitor);

    return visitor.conditionalsInfo
        .map((info) => createIssue(
              rule: this,
              location: nodeLocation(node: info.expression, source: source),
              message: _warning,
              replacement: _createReplacement(info),
            ))
        .toList(growable: false);
  }

  Replacement? _createReplacement(_ConditionalInfo info) {
    final condition = info.expression.condition;
    final correction = '${info.isInverted ? "!" : ""}$condition';

    return Replacement(comment: _correctionMessage, replacement: correction);
  }
}
