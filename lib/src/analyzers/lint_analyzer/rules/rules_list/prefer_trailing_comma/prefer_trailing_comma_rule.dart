// ignore_for_file: public_member_api_docs

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/syntactic_entity.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/source/line_info.dart';

import '../../../../../utils/node_utils.dart';
import '../../../lint_utils.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/issue.dart';
import '../../../models/replacement.dart';
import '../../../models/severity.dart';
import '../../models/common_rule.dart';
import '../../rule_utils.dart';

part 'config_parser.dart';
part 'visitor.dart';

class PreferTrailingCommaRule extends CommonRule {
  static const String ruleId = 'prefer-trailing-comma';

  static const _warningMessage = 'Prefer trailing comma.';
  static const _correctionMessage = 'Add trailing comma.';

  final int? _itemsBreakpoint;

  PreferTrailingCommaRule([Map<String, Object> config = const {}])
      : _itemsBreakpoint = _ConfigParser.parseBreakpoint(config),
        super(
          id: ruleId,
          severity: readSeverity(config, Severity.style),
          excludes: readExcludes(config),
          includes: readIncludes(config),
        );

  @override
  Map<String, Object?> toJson() {
    final json = super.toJson();
    json[_ConfigParser._breakOnConfigName] = _itemsBreakpoint;

    return json;
  }

  @override
  Iterable<Issue> check(InternalResolvedUnitResult source) {
    final visitor = _Visitor(source.lineInfo, _itemsBreakpoint);

    source.unit.visitChildren(visitor);

    return visitor.nodes
        .map(
          (node) => createIssue(
            rule: this,
            location: nodeLocation(node: node, source: source),
            message: _warningMessage,
            replacement: Replacement(
              comment: _correctionMessage,
              replacement:
                  '${source.content.substring(node.offset, node.end)},',
            ),
          ),
        )
        .toList(growable: false);
  }
}
