// ignore_for_file: public_member_api_docs

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

import '../../../../../utils/flutter_types_utils.dart';
import '../../../../../utils/node_utils.dart';
import '../../../lint_utils.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/issue.dart';
import '../../../models/severity.dart';
import '../../models/flutter_rule.dart';
import '../../rule_utils.dart';

part 'visitor.dart';

class AvoidUnnecessarySetStateRule extends FlutterRule {
  static const String ruleId = 'avoid-unnecessary-setstate';

  static const _warningMessage =
      'Avoid calling unnecessary setState. Consider changing the state directly.';
  static const _methodWarningMessage =
      'Avoid calling a sync method with setState.';

  AvoidUnnecessarySetStateRule([Map<String, Object> config = const {}])
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

    return [
      ...visitor.setStateInvocations.map((invocation) => createIssue(
            rule: this,
            location: nodeLocation(
              node: invocation,
              source: source,
            ),
            message: _warningMessage,
          )),
      ...visitor.classMethodsInvocations.map((invocation) => createIssue(
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
