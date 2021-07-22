import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

import '../../../../../utils/node_utils.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/issue.dart';
import '../../../models/severity.dart';
import '../../flutter_rule_utils.dart';
import '../../models/rule.dart';
import '../../models/rule_documentation.dart';
import '../../rule_utils.dart';

part 'visitor.dart';

class PreferSingleWidgetPerFileRule extends Rule {
  static const String ruleId = 'prefer-single-widget-per-file';

  static const _warningMessage = 'A maximum of widget per file is allowed.';

  PreferSingleWidgetPerFileRule([Map<String, Object> config = const {}])
      : super(
          id: ruleId,
          documentation: const RuleDocumentation(
            name: 'Prefer single widget per file',
            brief: 'A file may not contain more than one widget.',
          ),
          severity: readSeverity(config, Severity.style),
          excludes: readExcludes(config),
        );

  @override
  Iterable<Issue> check(InternalResolvedUnitResult source) {
    final visitor = _Visitor();

    source.unit.visitChildren(visitor);

    return visitor.nodes.length > 1
        ? visitor.nodes
            .skip(1)
            .map(
              (node) => createIssue(
                rule: this,
                location: nodeLocation(
                  node: node,
                  source: source,
                ),
                message: _warningMessage,
              ),
            )
            .toList(growable: false)
        : [];
  }
}
