import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

import '../../../../../utils/node_utils.dart';
import '../../../lint_utils.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/issue.dart';
import '../../../models/replacement.dart';
import '../../../models/severity.dart';
import '../../models/flutter_rule.dart';
import '../../models/rule_documentation.dart';
import '../../rule_utils.dart';

part 'visitor.dart';

class PreferConstBorderRadiusRule extends FlutterRule {
  static const ruleId = 'prefer-const-border-radius';
  static const _issueMessage = 'Prefer use const constructor BorderRadius.all.';
  static const _replaceComment = 'Replace with const BorderRadius constructor.';

  PreferConstBorderRadiusRule([Map<String, Object> config = const {}])
      : super(
          id: ruleId,
          documentation: const RuleDocumentation(
            name: 'Prefer const border radius',
            brief: 'Warns when used non const border radius.',
          ),
          severity: readSeverity(config, Severity.performance),
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
                withCommentOrMetadata: true,
              ),
              message: _issueMessage,
              replacement: _getValueFromAstNode(declaration) != null
                  ? Replacement(
                      comment: _replaceComment,
                      replacement: _getReplacementValue(declaration),
                    )
                  : null,
            ))
        .toList(growable: false);
  }

  String _getReplacementValue(AstNode declaration) {
    final value = _getValueFromAstNode(declaration);

    return 'BorderRadius.all(Radius.circular($value))';
  }
}

String? _getValueFromAstNode(AstNode borderRadius) {
  final paramsList = borderRadius.childEntities;

  return paramsList.isNotEmpty
      ? _getValueFromString(paramsList.last.toString())
      : null;
}

String? _getValueFromString(String value) =>
    value.length >= 3 && value.startsWith('(') && value.endsWith(')')
        ? value.substring(1, value.length - 1)
        : null;
