import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

import '../../../../../../lint_analyzer.dart';
import '../../../../../utils/node_utils.dart';
import '../../../lint_utils.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/issue.dart';
import '../../../models/severity.dart';
import '../../models/flutter_rule.dart';
import '../../models/rule_documentation.dart';
import '../../rule_utils.dart';

part 'visitor.dart';

class PreferConstBorderRadiusRule extends FlutterRule {
  static const String ruleId = 'prefer_const_border_radius';
  static const _preferConstBorderRadius =
      'Prefer use const constructor BorderRadius.all';

  PreferConstBorderRadiusRule([Map<String, Object> config = const {}])
      : super(
          id: ruleId,
          documentation: const RuleDocumentation(
            name: 'Prefer const border radius',
            brief: 'Warns when used non const border radius',
          ),
          severity: readSeverity(config, Severity.performance),
          excludes: readExcludes(config),
        );

  @override
  Iterable<Issue> check(InternalResolvedUnitResult source) {
    final visitor = _Visitor();
    source.unit.visitChildren(visitor);

    final _issue = _addIssues(source, visitor.constructorNodes);

    return _issue;
  }

  List<Issue> _addIssues(
    InternalResolvedUnitResult source,
    Iterable<TypeName> classNode,
  ) {
    final issue = <Issue>[];

    for (final element in classNode) {
      final borderRadius = _getBorderRadiusElementDeclaration(element);
      if (borderRadius != null) {
        final value = _getValueFromAstNode(borderRadius);

        issue.add(createIssue(
          rule: this,
          location: nodeLocation(
            node: borderRadius,
            source: source,
            withCommentOrMetadata: true,
          ),
          message: _preferConstBorderRadius,
          replacement: value != null
              ? Replacement(
                  comment: 'Replace with const constructor',
                  replacement: 'BorderRadius.all(Radius.circular($value))',
                )
              : null,
        ));
      }
    }

    return issue;
  }

  AstNode? _getBorderRadiusElementDeclaration(TypeName element) {
    final isBorderRadius =
        element.parent?.beginToken.lexeme == 'BorderRadius' &&
            element.parent?.endToken.lexeme == 'circular';

    return isBorderRadius ? element.parent!.parent : null;
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
}
