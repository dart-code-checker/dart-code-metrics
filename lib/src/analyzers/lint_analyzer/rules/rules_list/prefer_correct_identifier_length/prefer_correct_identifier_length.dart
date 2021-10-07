import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

import '../../../../../../lint_analyzer.dart';
import '../../../../../utils/node_utils.dart';
import '../../../lint_utils.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../models/common_rule.dart';
import '../../models/rule_documentation.dart';
import '../../rule_utils.dart';

part 'utils/config_parser.dart';

part 'visitor.dart';
part 'validator.dart';

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
            location: nodeLocation(node: node.name, source: source),
            message: createErrorMessage('variable', node.name.name),
          ),
        )
        .toList(growable: false);
  }

  String createErrorMessage(String type, String name) =>
      name.length > _validator.maxLength
          ? 'Too long $type name length.'
          : 'Too short $type name length.';
}
