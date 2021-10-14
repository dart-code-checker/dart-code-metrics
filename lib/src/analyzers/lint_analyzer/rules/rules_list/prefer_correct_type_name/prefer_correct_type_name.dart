import 'package:analyzer/dart/ast/ast.dart';

import '../../../../../utils/node_utils.dart';
import '../../../lint_utils.dart';
import '../../../metrics/scope_visitor.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/issue.dart';
import '../../../models/severity.dart';
import '../../models/common_rule.dart';
import '../../models/rule_documentation.dart';
import '../../rule_utils.dart';

part 'utils/config_parser.dart';

part 'validator.dart';

part 'visitor.dart';

class PreferCorrectTypeName extends CommonRule {
  static const String ruleId = 'prefer-correct-type-name';
  final _Validator _validator;

  PreferCorrectTypeName([Map<String, Object> config = const {}])
      : _validator = _Validator(
          _ConfigParser.readMaxIdentifierLength(config),
          _ConfigParser.readMinIdentifierLength(config),
          _ConfigParser.readExcludes(config),
        ),
        super(
          id: ruleId,
          documentation: const RuleDocumentation(
            name: 'Prefer correct type name',
            brief:
                'Type name should only contain alphanumeric characters, start with an uppercase character and span between min-length and max-length characters in length.',
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
            message:
                "The '$node' name should only contain alphanumeric characters, start with an uppercase character and span between ${_validator.minLength} and ${_validator.maxLength} characters in length",
          ),
        )
        .toList(growable: false);
  }
}
