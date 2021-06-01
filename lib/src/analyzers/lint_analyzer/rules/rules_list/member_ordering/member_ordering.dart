import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

import '../../../../../utils/node_utils.dart';
import '../../../../../utils/string_extension.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/issue.dart';
import '../../../models/severity.dart';
import '../../models/rule.dart';
import '../../models/rule_documentation.dart';
import '../../rule_utils.dart';

part 'config_parser.dart';
part 'visitor.dart';

// Inspired by TSLint (https://palantir.github.io/tslint/rules/member-ordering/)

class MemberOrderingRule extends Rule {
  static const ruleId = 'member-ordering';

  static const _warningMessage = 'should be before';
  static const _warningAlphabeticalMessage = 'should be alphabetically before';

  final List<_MembersGroup> _groupsOrder;
  final bool _alphabetize;

  MemberOrderingRule([Map<String, Object> config = const {}])
      : _groupsOrder = _ConfigParser.parseOrder(config),
        _alphabetize = _ConfigParser.parseAlphabetize(config),
        super(
          id: ruleId,
          documentation: const RuleDocumentation(
            name: 'Member ordering',
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
                  '${info.memberOrder.memberGroup.name} $_warningMessage ${info.memberOrder.previousMemberGroup?.name}.',
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
