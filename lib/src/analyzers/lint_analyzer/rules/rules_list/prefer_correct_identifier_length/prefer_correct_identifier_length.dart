import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/scope_visitor.dart';

import '../../../../../utils/node_utils.dart';
import '../../../lint_utils.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/issue.dart';
import '../../../models/severity.dart';
import '../../models/common_rule.dart';
import '../../models/rule_documentation.dart';
import '../../rule_utils.dart';

part 'utils/config_parser.dart';

part 'validator.dart';

part 'visitor.dart';

class PreferCorrectIdentifierLength extends CommonRule {
  static const String ruleId = 'prefer-correct-identifier-length';
  final _Validator _validator;

  PreferCorrectIdentifierLength([Map<String, Object> config = const {}])
      : _validator = _Validator(
          _ConfigParser.readMaxIdentifierLength(config),
          _ConfigParser.readMinIdentifierLength(config),
          _ConfigParser.readExceptions(config),
        ),
        super(
          id: ruleId,
          documentation: const RuleDocumentation(
            name: 'Prefer correct identifier length',
            brief: 'Warns when identifier name length very short or long.',
          ),
          severity: readSeverity(config, Severity.style),
          excludes: readExcludes(config),
        );

  @override
  Iterable<Issue> check(InternalResolvedUnitResult source) {
    final visitor = _Visitor(_validator);

    source.unit.visitChildren(visitor);

    return visitor.nodes
        .map(
          (node) => createIssue(
            rule: this,
            location: nodeLocation(node: node, source: source),
            message: createErrorMessage(node.name),
          ),
        )
        .toList(growable: false);
  }

  String createErrorMessage(String name) => name.length > _validator.maxLength
      ? 'Too long identifier name length.'
      : 'Too short identifier name length.';
}
