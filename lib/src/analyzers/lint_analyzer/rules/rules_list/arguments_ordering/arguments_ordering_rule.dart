// ignore_for_file: public_member_api_docs

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:collection/collection.dart';

import '../../../../../utils/node_utils.dart';
import '../../../lint_utils.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/issue.dart';
import '../../../models/replacement.dart';
import '../../../models/severity.dart';
import '../../models/common_rule.dart';
import '../../rule_utils.dart';

part 'config_parser.dart';
part 'visitor.dart';

class ArgumentsOrderingRule extends CommonRule {
  static const String ruleId = 'arguments-ordering';

  static const _warningMessage =
      'Named arguments should be sorted to match parameters declaration order.';
  static const _replaceComment = 'Sort arguments';

  final bool _childLast;

  ArgumentsOrderingRule([Map<String, Object> config = const {}])
      : _childLast = _ConfigParser.parseChildLast(config),
        super(
          id: ruleId,
          severity: readSeverity(config, Severity.style),
          excludes: readExcludes(config),
          includes: readIncludes(config),
        );

  @override
  Map<String, Object?> toJson() {
    final json = super.toJson();
    json[_ConfigParser._childLast] = _childLast;

    return json;
  }

  @override
  Iterable<Issue> check(InternalResolvedUnitResult source) {
    final visitor = _Visitor(childLast: _childLast);

    source.unit.visitChildren(visitor);

    return visitor.issues
        .map(
          (issue) => createIssue(
            rule: this,
            location: nodeLocation(node: issue.argumentList, source: source),
            message: _warningMessage,
            replacement: Replacement(
              comment: _replaceComment,
              replacement: issue.replacement,
            ),
          ),
        )
        .toList(growable: false);
  }
}
