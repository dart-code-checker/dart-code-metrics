// ignore_for_file: public_member_api_docs

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

import '../../../../../utils/node_utils.dart';
import '../../../lint_utils.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/issue.dart';
import '../../../models/replacement.dart';
import '../../../models/severity.dart';
import '../../models/common_rule.dart';
import '../../rule_utils.dart';

part 'visitor.dart';

class AvoidDoubleSlashImportsRule extends CommonRule {
  static const String ruleId = 'avoid-double-slash-imports';

  static const _warning = 'Avoid double slash import/export directives.';
  static const _correctionMessage = 'Remove double slash.';

  AvoidDoubleSlashImportsRule([Map<String, Object> config = const {}])
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

    return visitor.nodes
        .map(
          (node) => createIssue(
            rule: this,
            location: nodeLocation(node: node, source: source),
            message: _warning,
            replacement: _createReplacement(node),
          ),
        )
        .toList(growable: false);
  }

  Replacement _createReplacement(UriBasedDirective directive) {
    final updatedDirective =
        directive.toString().replaceAll('//', '/').replaceAll(r'\\', r'\');

    return Replacement(
      comment: _correctionMessage,
      replacement: updatedDirective,
    );
  }
}
