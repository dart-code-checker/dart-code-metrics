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

class AvoidThrowInCatchBlockRule extends CommonRule {
  static const String ruleId = 'avoid-throw-in-catch-block';

  static const _warningMessage =
      'Call throw in a catch block loses the original stack trace and the original exception.';

  AvoidThrowInCatchBlockRule([Map<String, Object> config = const {}])
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

    return visitor.throwExpression.map((expression) => createIssue(
          rule: this,
          location: nodeLocation(
            node: expression,
            source: source,
          ),
          message: _warningMessage,
        ));
  }
}
