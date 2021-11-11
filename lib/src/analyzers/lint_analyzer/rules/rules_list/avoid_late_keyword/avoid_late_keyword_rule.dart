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

class AvoidLateKeywordRule extends CommonRule {
  static const String ruleId = 'avoid-late-keyword';

  static const _warning = "Avoid using 'late' keyword.";

  AvoidLateKeywordRule([Map<String, Object> config = const {}])
      : super(
          id: ruleId,
          severity: readSeverity(config, Severity.warning),
          excludes: readExcludes(config),
        );

  @override
  Iterable<Issue> check(InternalResolvedUnitResult source) {
    final visitor = _Visitor();

    source.unit.visitChildren(visitor);

    return visitor.declarations
        .map((declaration) => createIssue(
              rule: this,
              location: nodeLocation(
                node: declaration,
                source: source,
              ),
              message: _warning,
            ))
        .toList(growable: false);
  }
}
