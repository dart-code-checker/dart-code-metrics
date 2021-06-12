import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

import '../../../../../utils/node_utils.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/issue.dart';
import '../../../models/severity.dart';
import '../../flutter_rule_utils.dart';
import '../../models/rule.dart';
import '../../models/rule_documentation.dart';
import '../../rule_utils.dart';

part 'visitor.dart';

class AvoidUnnecessarySetStateRule extends Rule {
  static const String ruleId = 'avoid-unnecessary-setstate';

  static const _warningMessage =
      'Avoid calling unnecessary setState. Consider changing the state directly.';
  static const _methodWarningMessage =
      'Avoid calling a sync method with setState.';

  AvoidUnnecessarySetStateRule([Map<String, Object> config = const {}])
      : super(
          id: ruleId,
          documentation: const RuleDocumentation(
            name: 'Avoid returning widgets',
            brief:
                'Warns when `setState` is called inside `initState`, `didUpdateWidget` or `build` methods and when it is called from a `sync` method that is called inside those methods.',
          ),
          severity: readSeverity(config, Severity.warning),
          excludes: readExcludes(config),
        );

  @override
  Iterable<Issue> check(InternalResolvedUnitResult source) {
    final _visitor = _Visitor();

    source.unit.visitChildren(_visitor);

    return [
      ..._visitor.setStateInvocations.map((invocation) => createIssue(
            rule: this,
            location: nodeLocation(
              node: invocation,
              source: source,
            ),
            message: _warningMessage,
          )),
      ..._visitor.classMethodsInvocations.map((invocation) => createIssue(
            rule: this,
            location: nodeLocation(
              node: invocation,
              source: source,
            ),
            message: _methodWarningMessage,
          )),
    ];
  }
}
