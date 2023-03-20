// ignore_for_file: public_member_api_docs

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

import '../../../../../utils/node_utils.dart';
import '../../../lint_utils.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/issue.dart';
import '../../../models/severity.dart';
import '../../models/flutter_rule.dart';
import '../../rule_utils.dart';

part 'visitor.dart';

class PreferDefineHeroTagRule extends FlutterRule {
  static const ruleId = 'prefer-define-hero-tag';
  static const _issueMessage = 'Prefer define heroTag property.';

  PreferDefineHeroTagRule([Map<String, Object> config = const {}])
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

    return visitor.invocations
        .map((invocation) => createIssue(
              rule: this,
              location: nodeLocation(node: invocation, source: source),
              message: _issueMessage,
            ))
        .toList(growable: false);
  }
}
