// ignore_for_file: public_member_api_docs

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
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

class AvoidExtendsKeywordRule extends FlutterRule {
  static const ruleId = 'avoid-extends-keyword';
  static const _issueMessage =
      'Prefer using implements keyword for abstract classes';
  static const _replaceComment = 'Replace extends to implements keyword';

  AvoidExtendsKeywordRule([Map<String, Object> config = const {}])
      : super(
          id: ruleId,
          severity: readSeverity(config, Severity.style),
          excludes: readExcludes(config),
        );

  @override
  Iterable<Issue> check(InternalResolvedUnitResult source) {
    final visitor = _Visitor();
    source.unit.visitChildren(visitor);

    return visitor.expressions
        .map((expression) => createIssue(
              rule: this,
              location: nodeLocation(
                node: expression,
                source: source,
                withCommentOrMetadata: true,
              ),
              message: _issueMessage,
              replacement: _createReplacement(expression),
            ))
        .toList(growable: false);
  }

  Replacement? _createReplacement(ClassDeclaration expression) => Replacement(
        comment: _replaceComment,
        replacement:
            expression.toString().replaceFirst('extends', 'implements'),
      );
}
