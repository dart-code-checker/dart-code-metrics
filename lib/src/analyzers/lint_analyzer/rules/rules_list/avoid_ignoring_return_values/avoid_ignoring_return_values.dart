import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';

import '../../../../../utils/node_utils.dart';
import '../../../lint_utils.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/issue.dart';
import '../../../models/severity.dart';
import '../../models/common_rule.dart';
import '../../models/rule_documentation.dart';
import '../../rule_utils.dart';

part 'visitor.dart';

class AvoidIgnoringReturnValuesRule extends CommonRule {
  static const String ruleId = 'avoid-ignoring-return-values';

  static const _warning = 'Avoid ignoring return values.';

  AvoidIgnoringReturnValuesRule([Map<String, Object> config = const {}])
      : super(
          id: ruleId,
          documentation: const RuleDocumentation(
            name: 'Avoid ignoring return values.',
            brief:
                'Warns when a return value of a method or function invocation or a class instance property access is not used.',
          ),
          severity: readSeverity(config, Severity.warning),
          excludes: readExcludes(config),
        );

  @override
  Iterable<Issue> check(InternalResolvedUnitResult source) {
    final visitor = _Visitor();

    source.unit.visitChildren(visitor);

    return visitor.statements
        .map((statement) => createIssue(
              rule: this,
              location: nodeLocation(
                node: statement,
                source: source,
              ),
              message: _warning,
            ))
        .toList(growable: false);
  }
}
