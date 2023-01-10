// ignore_for_file: public_member_api_docs

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';

import '../../../../../utils/node_utils.dart';
import '../../../lint_utils.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/issue.dart';
import '../../../models/severity.dart';
import '../../models/common_rule.dart';
import '../../rule_utils.dart';

part 'config_parser.dart';
part 'visitor.dart';

class PreferMovingToVariableRule extends CommonRule {
  static const String ruleId = 'prefer-moving-to-variable';

  static const _warningMessage =
      'Prefer moving repeated invocations to variable and use it instead.';

  final int? _duplicatesThreshold;

  PreferMovingToVariableRule([Map<String, Object> config = const {}])
      : _duplicatesThreshold =
            _ConfigParser.parseAllowedDuplicatedChains(config),
        super(
          id: ruleId,
          severity: readSeverity(config, Severity.warning),
          excludes: readExcludes(config),
          includes: readIncludes(config),
        );

  @override
  Map<String, Object?> toJson() {
    final json = super.toJson();
    json[_ConfigParser._allowedDuplicatedChains] = _duplicatesThreshold;

    return json;
  }

  @override
  Iterable<Issue> check(InternalResolvedUnitResult source) {
    final visitor = _Visitor(_duplicatesThreshold);

    source.unit.visitChildren(visitor);

    return visitor.nodes
        .map((node) => createIssue(
              rule: this,
              location: nodeLocation(node: node, source: source),
              message: _warningMessage,
            ))
        .toList(growable: false);
  }
}
