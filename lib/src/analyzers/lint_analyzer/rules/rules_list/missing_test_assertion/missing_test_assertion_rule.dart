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

part 'config_parser.dart';
part 'visitor.dart';

class MissingTestAssertionRule extends CommonRule {
  static const String ruleId = 'missing-test-assertion';

  static const _warningMessage = 'Missing test assertion.';

  final Iterable<String> _includeAssertions;
  final Iterable<String> _includeMethods;

  MissingTestAssertionRule([Map<String, Object> config = const {}])
      : _includeAssertions = _ConfigParser.parseIncludeAssertions(config),
        _includeMethods = _ConfigParser.parseIncludeMethods(config),
        super(
          id: ruleId,
          severity: readSeverity(config, Severity.warning),
          excludes: readExcludes(config),
          includes: hasIncludes(config) ? readIncludes(config) : ['test/**'],
        );

  @override
  Map<String, Object?> toJson() {
    final json = super.toJson();
    json[_ConfigParser._includeAssertionsConfig] = _includeAssertions.toList();
    json[_ConfigParser._includeMethodsConfig] = _includeMethods.toList();

    return json;
  }

  @override
  Iterable<Issue> check(InternalResolvedUnitResult source) {
    final visitor = _Visitor(_includeAssertions, _includeMethods);

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
