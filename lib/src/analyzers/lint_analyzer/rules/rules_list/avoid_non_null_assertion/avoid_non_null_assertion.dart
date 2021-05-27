import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';

import '../../../../../utils/node_utils.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/issue.dart';
import '../../../models/severity.dart';
import '../../models/rule.dart';
import '../../models/rule_documentation.dart';
import '../../rule_utils.dart';

part 'visitor.dart';

class AvoidNonNullAssertionRule extends Rule {
  static const String ruleId = 'avoid-non-null-assertion';

  static const _warning = 'Avoid using non null assertion.';

  AvoidNonNullAssertionRule([Map<String, Object> config = const {}])
      : super(
          id: ruleId,
          documentation: const RuleDocumentation(
            name: 'Avoid non null assertion',
            brief:
                'Warns when non null assertion operator (or “bang” operator) is used for a property access or method invocation. The operator check works at runtime and it may fail and throw a runtime exception.',
          ),
          severity: readSeverity(config, Severity.warning),
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
              ),
              message: _warning,
            ))
        .toList(growable: false);
  }
}
