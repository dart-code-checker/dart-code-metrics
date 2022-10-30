// ignore_for_file: public_member_api_docs

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:collection/collection.dart';

import '../../../../../utils/node_utils.dart';
import '../../../lint_utils.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/issue.dart';
import '../../../models/severity.dart';
import '../../models/angular_rule.dart';
import '../../rule_utils.dart';

part 'visitor.dart';

class AvoidPreserveWhitespaceFalseRule extends AngularRule {
  static const String ruleId = 'avoid-preserve-whitespace-false';

  static const _warning = 'Avoid using preserveWhitespace: false.';

  AvoidPreserveWhitespaceFalseRule([Map<String, Object> config = const {}])
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

    return visitor.expression
        .map((expression) => createIssue(
              rule: this,
              location: nodeLocation(node: expression, source: source),
              message: _warning,
            ))
        .toList(growable: false);
  }
}
