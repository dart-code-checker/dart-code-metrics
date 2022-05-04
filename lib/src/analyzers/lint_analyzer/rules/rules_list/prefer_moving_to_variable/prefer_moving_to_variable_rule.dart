// ignore_for_file: public_member_api_docs

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

import '../../../../../utils/node_utils.dart';
import '../../../lint_utils.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/issue.dart';
import '../../../models/severity.dart';
import '../../models/common_rule.dart';
import '../../rule_utils.dart';

part 'visitor.dart';

class PreferMovingToVariableRule extends CommonRule {
  static const String ruleId = 'prefer-moving-to-variable';

  static const _warningMessage =
      'Prefer moving repeated invocations to variable and use it instead.';

  PreferMovingToVariableRule([Map<String, Object> config = const {}])
      : super(
          id: ruleId,
          severity: readSeverity(config, Severity.warning),
          excludes: readExcludes(config),
        );

  @override
  Iterable<Issue> check(InternalResolvedUnitResult source) {
    final visitor = _Visitor();

    source.unit.visitChildren(visitor);

    return visitor.nodes
        .map((node) => createIssue(
              rule: this,
              location: nodeLocation(node: node, source: source),
              message: _warningMessage,
            ))
        .toList(growable: false);
  }
}
