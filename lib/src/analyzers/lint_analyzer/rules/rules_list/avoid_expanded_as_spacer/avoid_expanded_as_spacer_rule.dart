// ignore_for_file: public_member_api_docs

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

import '../../../../../utils/node_utils.dart';
import '../../../lint_utils.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/issue.dart';
import '../../../models/replacement.dart';
import '../../../models/severity.dart';
import '../../models/flutter_rule.dart';
import '../../rule_utils.dart';

part 'visitor.dart';

class AvoidExpandedAsSpacerRule extends FlutterRule {
  static const ruleId = 'avoid-expanded-as-spacer';
  static const _issueMessage =
      'Prefer using Spacer widget instead of Expanded.';
  static const _replaceComment = 'Replace with Spacer widget.';

  AvoidExpandedAsSpacerRule([Map<String, Object> config = const {}])
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

    return visitor.expressions
        .map((expression) => createIssue(
              rule: this,
              location: nodeLocation(node: expression, source: source),
              message: _issueMessage,
              replacement: const Replacement(
                comment: _replaceComment,
                replacement: 'const Spacer()',
              ),
            ))
        .toList(growable: false);
  }
}
