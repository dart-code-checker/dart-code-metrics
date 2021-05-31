import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

import '../../../../../utils/node_utils.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/issue.dart';
import '../../../models/severity.dart';
import '../../models/rule.dart';
import '../../models/rule_documentation.dart';
import '../../rule_utils.dart';

part 'visitor.dart';

// Inspired by PVS-Studio (https://www.viva64.com/en/w/v6004/)

class NoEqualThenElseRule extends Rule {
  static const String ruleId = 'no-equal-then-else';

  static const _warningMessage = 'Then and else branches are equal.';

  NoEqualThenElseRule([Map<String, Object> config = const {}])
      : super(
          id: ruleId,
          documentation: const RuleDocumentation(
            name: 'No equal then else',
            brief:
                'Warns when if statement has equal then and else statements or conditional expression has equal then and else expressions.',
          ),
          severity: readSeverity(config, Severity.warning),
          excludes: readExcludes(config),
        );

  @override
  Iterable<Issue> check(InternalResolvedUnitResult source) {
    final _visitor = _Visitor();

    source.unit.visitChildren(_visitor);

    return _visitor.nodes
        .map(
          (node) => createIssue(
            rule: this,
            location: nodeLocation(
              node: node,
              source: source,
              withCommentOrMetadata: true,
            ),
            message: _warningMessage,
          ),
        )
        .toList(growable: false);
  }
}
