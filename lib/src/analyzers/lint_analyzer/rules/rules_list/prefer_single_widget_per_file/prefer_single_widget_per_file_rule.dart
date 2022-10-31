// ignore_for_file: public_member_api_docs

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

import '../../../../../utils/flutter_types_utils.dart';
import '../../../../../utils/node_utils.dart';
import '../../../lint_utils.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/issue.dart';
import '../../../models/severity.dart';
import '../../models/flutter_rule.dart';
import '../../rule_utils.dart';

part 'config_parser.dart';
part 'visitor.dart';

class PreferSingleWidgetPerFileRule extends FlutterRule {
  static const String ruleId = 'prefer-single-widget-per-file';

  static const _warningMessage = 'Only a single widget per file is allowed.';

  final bool _ignorePrivateWidgets;

  PreferSingleWidgetPerFileRule([Map<String, Object> config = const {}])
      : _ignorePrivateWidgets = _ConfigParser.parseIgnorePrivateWidgets(config),
        super(
          id: ruleId,
          severity: readSeverity(config, Severity.style),
          excludes: readExcludes(config),
          includes: readIncludes(config),
        );

  @override
  Map<String, Object?> toJson() {
    final json = super.toJson();
    json[_ConfigParser._ignorePrivateWidgetsName] = _ignorePrivateWidgets;

    return json;
  }

  @override
  Iterable<Issue> check(InternalResolvedUnitResult source) {
    final visitor = _Visitor(ignorePrivateWidgets: _ignorePrivateWidgets);

    source.unit.visitChildren(visitor);

    return visitor.nodes
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
        .toList(growable: false);
  }
}
