// ignore_for_file: public_member_api_docs

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/type.dart';

import '../../../../../utils/node_utils.dart';
import '../../../lint_utils.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/issue.dart';
import '../../../models/severity.dart';
import '../../models/common_rule.dart';
import '../../rule_utils.dart';

part 'visitor.dart';

class AvoidPassingAsyncWhenSyncExpectedRule extends CommonRule {
  static const String ruleId = 'avoid-passing-async-when-sync-expected';

  static const _warningMessage = 'Expected a sync function but got async.';

  AvoidPassingAsyncWhenSyncExpectedRule([Map<String, Object> config = const {}])
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

    return visitor.invalidArguments
        .map((invocation) => createIssue(
              rule: this,
              location: nodeLocation(node: invocation, source: source),
              message: _warningMessage,
            ))
        .toList(growable: false);
  }
}
