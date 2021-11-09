import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/type.dart';

import '../../../../../utils/node_utils.dart';
import '../../../lint_utils.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/issue.dart';
import '../../../models/severity.dart';
import '../../dart_rule_utils.dart';
import '../../models/common_rule.dart';
import '../../models/rule_documentation.dart';
import '../../rule_utils.dart';

part 'visitor.dart';

class AvoidUnnecessaryTypeAssertions extends CommonRule {
  static const String ruleId = 'avoid-unnecessary-type-assertions';

  AvoidUnnecessaryTypeAssertions([Map<String, Object> config = const {}])
      : super(
          id: ruleId,
          documentation: const RuleDocumentation(
            name: 'AvoidUnnecessaryTypeAssertions',
            brief: 'Avoid unnecessary type assertions',
          ),
          severity: readSeverity(config, Severity.style),
          excludes: readExcludes(config),
        );

  @override
  Iterable<Issue> check(InternalResolvedUnitResult source) {
    final visitor = _Visitor();

    source.unit.visitChildren(visitor);

    return visitor.expressions.entries
        .map(
          (node) => createIssue(
            rule: this,
            location: nodeLocation(node: node.key, source: source),
            message: 'Avoid redundant "${node.value}" assertion.',
          ),
        )
        .toList(growable: false);
  }
}
