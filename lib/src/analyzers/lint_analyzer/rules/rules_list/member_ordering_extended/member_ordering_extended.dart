import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

import '../../../../../utils/node_utils.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/issue.dart';
import '../../../models/severity.dart';
import '../../models/rule.dart';
import '../../models/rule_documentation.dart';
import '../../rule_utils.dart';

part 'config_parser.dart';
part 'models/annotation.dart';
part 'models/field_keyword.dart';
part 'models/member_group.dart';
part 'models/member_type.dart';
part 'models/modifier.dart';
part 'visitor.dart';

class MemberOrderingExtendedRule extends Rule {
  static const ruleId = 'member-ordering-extended';

  static const _warningMessage = 'should be before';
  static const _warningAlphabeticalMessage = 'should be alphabetically before';

  final List<_MemberGroup> _groupsOrder;
  final bool _alphabetize;

  MemberOrderingExtendedRule([Map<String, Object> config = const {}])
      : _groupsOrder = _ConfigParser.parseOrder(config),
        _alphabetize = _ConfigParser.parseAlphabetize(config),
        super(
          id: ruleId,
          documentation: const RuleDocumentation(
            name: 'Member ordering extended',
            brief: 'Enforces ordering for a class members.',
          ),
          severity: readSeverity(config, Severity.style),
          excludes: readExcludes(config),
        );

  @override
  Iterable<Issue> check(InternalResolvedUnitResult source) {
    final _visitor = _Visitor(_groupsOrder);

    final membersInfo = [
      for (final entry in source.unit.childEntities)
        if (entry is ClassDeclaration) ...entry.accept(_visitor)!,
    ];

    return [
      ...membersInfo.where((info) => info.memberOrder.isWrong).map(
            (info) => createIssue(
              rule: this,
              location: nodeLocation(
                node: info.classMember,
                source: source,
                withCommentOrMetadata: true,
              ),
              message:
                  '${info.memberOrder.memberGroup} $_warningMessage ${info.memberOrder.previousMemberGroup}.',
            ),
          ),
      if (_alphabetize)
        ...membersInfo
            .where((info) => info.memberOrder.isAlphabeticallyWrong)
            .map(
              (info) => createIssue(
                rule: this,
                location: nodeLocation(
                  node: info.classMember,
                  source: source,
                  withCommentOrMetadata: true,
                ),
                message:
                    '${info.memberOrder.memberNames.currentName} $_warningAlphabeticalMessage ${info.memberOrder.memberNames.previousName}.',
              ),
            ),
    ];
  }
}
