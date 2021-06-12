import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:collection/collection.dart';

import '../../../../../utils/node_utils.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/issue.dart';
import '../../../models/severity.dart';
import '../../flutter_rule_utils.dart';
import '../../models/rule.dart';
import '../../models/rule_documentation.dart';
import '../../rule_utils.dart';

part 'visitor.dart';

class AlwaysRemoveListenerRule extends Rule {
  static const String ruleId = 'always-remove-listener';

  static const _warningMessage =
      'Listener is not removed. This might lead to a memory leak.';

  AlwaysRemoveListenerRule([Map<String, Object> config = const {}])
      : super(
          id: ruleId,
          documentation: const RuleDocumentation(
            name: 'Always remove listener',
            brief: 'Warns when an event listener is added but never removed.',
          ),
          severity: readSeverity(config, Severity.warning),
          excludes: readExcludes(config),
        );

  @override
  Iterable<Issue> check(InternalResolvedUnitResult source) {
    final _visitor = _Visitor();

    source.unit.visitChildren(_visitor);

    return _visitor.missingInvocations
        .map((invocation) => createIssue(
              rule: this,
              location: nodeLocation(
                node: invocation,
                source: source,
              ),
              message: _warningMessage,
            ))
        .toList(growable: false);
  }
}
