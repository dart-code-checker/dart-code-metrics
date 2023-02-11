// ignore_for_file: public_member_api_docs

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:collection/collection.dart';

import '../../../../../utils/dart_types_utils.dart';
import '../../../../../utils/flutter_types_utils.dart';
import '../../../../../utils/node_utils.dart';
import '../../../lint_utils.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/issue.dart';
import '../../../models/severity.dart';
import '../../models/common_rule.dart';
import '../../rule_utils.dart';

part 'config_parser.dart';
part 'models/annotation.dart';
part 'models/field_keyword.dart';
part 'models/member_group.dart';
part 'models/member_type.dart';
part 'models/modifier.dart';
part 'visitor.dart';

class MemberOrderingRule extends CommonRule {
  static const ruleId = 'member-ordering';

  static const _warningMessage = 'should be before';
  static const _warningAlphabeticalMessage = 'should be alphabetically before';
  static const _warningTypeAlphabeticalMessage =
      'type name should be alphabetically before';

  final List<_MemberGroup> _groupsOrder;
  final List<_MemberGroup> _widgetsGroupsOrder;
  final bool _alphabetize;
  final bool _alphabetizeByType;

  MemberOrderingRule([Map<String, Object> config = const {}])
      : _groupsOrder = _ConfigParser.parseOrder(config),
        _widgetsGroupsOrder = _ConfigParser.parseWidgetsOrder(config),
        _alphabetize = _ConfigParser.parseAlphabetize(config),
        _alphabetizeByType = _ConfigParser.parseAlphabetizeByType(config),
        super(
          id: ruleId,
          severity: readSeverity(config, Severity.style),
          excludes: readExcludes(config),
          includes: readIncludes(config),
        );

  @override
  Map<String, Object?> toJson() {
    final json = super.toJson();
    json[_ConfigParser._orderConfig] =
        _groupsOrder.map((group) => group.rawRepresentation).toList();
    json[_ConfigParser._widgetsOrderConfig] =
        _widgetsGroupsOrder.map((group) => group.rawRepresentation).toList();
    json[_ConfigParser._alphabetizeConfig] = _alphabetize;
    json[_ConfigParser._alphabetizeByTypeConfig] = _alphabetizeByType;

    return json;
  }

  @override
  Iterable<Issue> check(InternalResolvedUnitResult source) {
    final visitor = _Visitor(_groupsOrder, _widgetsGroupsOrder);

    final membersInfo = [
      for (final entry in source.unit.childEntities)
        if (entry is ClassDeclaration) ...entry.accept(visitor)!,
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
            .map((info) {
          final names = info.memberOrder.memberNames;

          return createIssue(
            rule: this,
            location: nodeLocation(
              node: info.classMember,
              source: source,
              withCommentOrMetadata: true,
            ),
            message:
                '${names.currentName} $_warningAlphabeticalMessage ${names.previousName}.',
          );
        }),
      if (!_alphabetize && _alphabetizeByType)
        ...membersInfo.where((info) => info.memberOrder.isByTypeWrong).map(
              (info) => createIssue(
                rule: this,
                location: nodeLocation(
                  node: info.classMember,
                  source: source,
                  withCommentOrMetadata: true,
                ),
                message:
                    '${info.memberOrder.memberNames.currentName} $_warningTypeAlphabeticalMessage ${info.memberOrder.memberNames.previousName}.',
              ),
            ),
    ];
  }
}
