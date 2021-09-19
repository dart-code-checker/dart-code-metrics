import 'package:analyzer/dart/ast/ast.dart';

import '../../../../../../lint_analyzer.dart';
import '../../../../../utils/node_utils.dart';
import '../../../lint_utils.dart';
import '../../../metrics/scope_visitor.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/issue.dart';
import '../../../models/severity.dart';
import '../../models/flutter_rule.dart';
import '../../models/rule_documentation.dart';
import '../../rule_utils.dart';

part 'visitor.dart';

class PreferConstBorderRadius extends FlutterRule {
  static const String ruleId = 'prefer_const_border_radius';
  static const _preferConstBorderRadius = 'Prefer const border radius';

  PreferConstBorderRadius([Map<String, Object> config = const {}])
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
    Iterable<ConstructorDeclaration> classNode,
  ) {
    final issue = <Issue>[];

    for (final element in classNode) {
      if (_isNonConstantBorderRadius(element)) {

        final param = element.parameters.parameters.first;
        issue.add(createIssue(
          rule: this,
          location: nodeLocation(
            node: element,
            source: source,
            withCommentOrMetadata: true,
          ),
          message: _preferConstBorderRadius,
          replacement: Replacement(
            comment: 'Replace to const constructor',
            replacement:
                'BorderRadius.all(Radius.circular($param))',
          ),
        ));
      }
    }

    return issue;
  }

  bool _isNonConstantBorderRadius(ConstructorDeclaration element) =>
      element.returnType.name == 'BorderRadius' &&
      element.name?.name == 'circular';
}
