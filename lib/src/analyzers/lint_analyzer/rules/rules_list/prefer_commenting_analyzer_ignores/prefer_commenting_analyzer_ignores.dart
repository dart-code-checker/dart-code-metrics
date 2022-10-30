import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/source/line_info.dart';

import '../../../../../utils/node_utils.dart';
import '../../../lint_utils.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/issue.dart';
import '../../../models/severity.dart';
import '../../models/common_rule.dart';
import '../../rule_utils.dart';

part 'visitor.dart';

class PreferCommentingAnalyzerIgnores extends CommonRule {
  static const String ruleId = 'prefer-commenting-analyzer-ignores';

  static const _warning = 'Prefer commenting analyzer ignores.';

  PreferCommentingAnalyzerIgnores([Map<String, Object> config = const {}])
      : super(
          id: ruleId,
          severity: readSeverity(config, Severity.warning),
          excludes: readExcludes(config),
          includes: readIncludes(config),
        );

  @override
  Iterable<Issue> check(InternalResolvedUnitResult source) {
    final visitor = _Visitor(source.lineInfo)..checkComments(source.unit.root);

    return visitor.comments.map((comment) => createIssue(
          rule: this,
          location: nodeLocation(
            node: comment,
            source: source,
          ),
          message: _warning,
        ));
  }
}
