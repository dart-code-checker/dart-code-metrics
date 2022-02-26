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

class TagNameRule extends CommonRule {
  static const String ruleId = 'tag-name';

  static const _warning = 'Incorrect tag name';

  final _ParsedConfig _parsedConfig;

  TagNameRule([Map<String, Object> config = const {}])
      : _parsedConfig = _ConfigParser._parseConfig(config),
        super(
          id: ruleId,
          severity: readSeverity(config, Severity.warning),
          excludes: readExcludes(config),
        );

  @override
  Iterable<Issue> check(InternalResolvedUnitResult source) {
    final visitor = _Visitor(_parsedConfig);

    source.unit.visitChildren(visitor);

    return visitor.nodes
        .map((node) => createIssue(
              rule: this,
              location: nodeLocation(
                node: node,
                source: source,
              ),
              message: _warning,
            ))
        .toList(growable: false);
  }
}
