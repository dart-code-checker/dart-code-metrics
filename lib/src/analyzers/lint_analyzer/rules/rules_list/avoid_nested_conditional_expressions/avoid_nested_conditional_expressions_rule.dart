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

part 'config_parser.dart';
part 'visitor.dart';

class AvoidNestedConditionalExpressionsRule extends CommonRule {
  static const String ruleId = 'avoid-nested-conditional-expressions';

  static const _warning = 'Avoid nested conditional expressions.';

  final int _acceptableLevel;

  AvoidNestedConditionalExpressionsRule([Map<String, Object> config = const {}])
      : _acceptableLevel = _ConfigParser.parseAcceptableLevel(config),
        super(
          id: ruleId,
          severity: readSeverity(config, Severity.style),
          excludes: readExcludes(config),
          includes: readIncludes(config),
        );

  @override
  Map<String, Object?> toJson() {
    final json = super.toJson();
    json[_ConfigParser._acceptableLevelConfig] = _acceptableLevel;

    return json;
  }

  @override
  Iterable<Issue> check(InternalResolvedUnitResult source) {
    final visitor = _Visitor(_acceptableLevel);

    source.unit.visitChildren(visitor);

    return visitor.expressions
        .map((expression) => createIssue(
              rule: this,
              location: nodeLocation(
                node: expression,
                source: source,
              ),
              message: _warning,
            ))
        .toList(growable: false);
  }
}
