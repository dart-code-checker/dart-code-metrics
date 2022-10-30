// ignore_for_file: public_member_api_docs

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';

import '../../../../../utils/node_utils.dart';
import '../../../lint_utils.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/issue.dart';
import '../../../models/severity.dart';
import '../../models/common_rule.dart';
import '../../rule_utils.dart';

part 'visitor.dart';

class PreferEnumsByNameRule extends CommonRule {
  static const ruleId = 'prefer-enums-by-name';
  static const _warningMessage = 'Prefer using values.byName';

  PreferEnumsByNameRule([Map<String, Object> config = const {}])
      : super(
          id: ruleId,
          severity: readSeverity(config, Severity.style),
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
              location: nodeLocation(
                node: invocation,
                source: source,
                withCommentOrMetadata: false,
              ),
              message: _warningMessage,
            ))
        .toList(growable: false);
  }
}
