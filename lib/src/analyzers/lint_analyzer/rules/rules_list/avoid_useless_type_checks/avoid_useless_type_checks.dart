import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

import '../../../../../utils/node_utils.dart';
import '../../../lint_utils.dart';
import '../../../metrics/scope_visitor.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/issue.dart';
import '../../../models/severity.dart';
import '../../models/common_rule.dart';
import '../../models/rule_documentation.dart';
import '../../rule_utils.dart';

part 'visitor.dart';

class AvoidUselessTypeChecks extends CommonRule {
  static const String ruleId = 'avoid-useless-type-checks';

  AvoidUselessTypeChecks([Map<String, Object> config = const {}])
      : super(
          id: ruleId,
          documentation: const RuleDocumentation(
            name: 'Avoid useless type checks',
            brief: 'Avoid useless type checks.',
          ),
          severity: readSeverity(config, Severity.style),
          excludes: readExcludes(config),
        );

  @override
  Iterable<Issue> check(InternalResolvedUnitResult source) {
    final visitor = _Visitor();

    source.unit.visitChildren(visitor);

    return visitor.expressions
        .map(
          (node) => createIssue(
            rule: this,
            location: nodeLocation(node: node, source: source),
            message: 'Avoid useless type checks.',
          ),
        )
        .toList(growable: false);
  }
}
