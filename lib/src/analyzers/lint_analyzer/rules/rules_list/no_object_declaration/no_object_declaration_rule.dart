// ignore_for_file: public_member_api_docs

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

import '../../../../../utils/node_utils.dart';
import '../../../lint_utils.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/issue.dart';
import '../../../models/severity.dart';
import '../../models/common_rule.dart';
import '../../rule_utils.dart';

part 'visitor.dart';

class NoObjectDeclarationRule extends CommonRule {
  static const String ruleId = 'no-object-declaration';

  static const _warningMessage =
      'Avoid Object type declaration in class member.';

  NoObjectDeclarationRule([Map<String, Object> config = const {}])
      : super(
          id: ruleId,
          severity: readSeverity(config, Severity.style),
          excludes: readExcludes(config),
        );

  @override
  Iterable<Issue> check(InternalResolvedUnitResult source) {
    final _visitor = _Visitor();

    source.unit.visitChildren(_visitor);

    return _visitor.members
        .map(
          (member) => createIssue(
            rule: this,
            location: nodeLocation(
              node: member,
              source: source,
              withCommentOrMetadata: true,
            ),
            message: _warningMessage,
          ),
        )
        .toList(growable: false);
  }
}
