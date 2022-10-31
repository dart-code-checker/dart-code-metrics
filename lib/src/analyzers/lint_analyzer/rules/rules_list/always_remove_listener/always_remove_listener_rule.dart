// ignore_for_file: public_member_api_docs

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:collection/collection.dart';

import '../../../../../utils/flutter_types_utils.dart';
import '../../../../../utils/node_utils.dart';
import '../../../lint_utils.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/issue.dart';
import '../../../models/severity.dart';
import '../../models/flutter_rule.dart';
import '../../rule_utils.dart';

part 'visitor.dart';

class AlwaysRemoveListenerRule extends FlutterRule {
  static const String ruleId = 'always-remove-listener';

  static const _warningMessage =
      'Listener is not removed. This might lead to a memory leak.';

  AlwaysRemoveListenerRule([Map<String, Object> config = const {}])
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

    return visitor.missingInvocations
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
