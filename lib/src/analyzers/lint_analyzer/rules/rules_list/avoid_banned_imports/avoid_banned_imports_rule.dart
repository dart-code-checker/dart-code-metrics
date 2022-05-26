// ignore_for_file: public_member_api_docs

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

import '../../../../../utils/node_utils.dart';
import '../../../lint_utils.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/issue.dart';
import '../../../models/severity.dart';
import '../../models/common_rule.dart';
import '../../rule_utils.dart';

part 'visitor.dart';

part 'utils/config_parser.dart';

class AvoidBannedImportsRule extends CommonRule {
  static const String ruleId = 'avoid-banned-imports';

  final List<_AvoidBannedImportsConfigEntry> _entries;

  AvoidBannedImportsRule([Map<String, Object> config = const {}])
      : _entries = _ConfigParser._parseEntryConfig(config),
        super(
          id: ruleId,
          severity: readSeverity(config, Severity.style),
          excludes: readExcludes(config),
        );

  @override
  Iterable<Issue> check(InternalResolvedUnitResult source) {
    final activeEntries =
        _entries.where((entry) => entry.paths.any((path) => _globMatch(pattern: path, data: source.path))).toList();

    final visitor = _Visitor(activeEntries);

    source.unit.visitChildren(visitor);

    return visitor.nodes
        .map(
          (node) => createIssue(
            rule: this,
            location: nodeLocation(node: node.node, source: source),
            message: node.message,
          ),
        )
        .toList(growable: false);
  }
}
