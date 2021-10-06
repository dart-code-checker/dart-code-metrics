import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

import '../../../../../../lint_analyzer.dart';
import '../../../../../utils/node_utils.dart';
import '../../../lint_utils.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../models/common_rule.dart';
import '../../models/rule_documentation.dart';
import '../../rule_utils.dart';
import 'utils/correct_identifier_length_validator.dart';

part 'utils/config_parser.dart';

part 'visitor.dart';

class PreferCorrectIdentifierLength extends CommonRule {
  static const String ruleId = 'prefer-correct-identifier-length';

  final int _minLength;

  final int _maxLength;

  final Iterable<String> _exceptions;

  PreferCorrectIdentifierLength([Map<String, Object> config = const {}])
      : _minLength = _ConfigParser.readMinIdentifierLength(config),
        _maxLength = _ConfigParser.readMaxIdentifierLength(config),
        _exceptions = _ConfigParser.readExceptions(config),
        super(
          id: ruleId,
          documentation: const RuleDocumentation(
            name: 'Prefer correct identifier length',
            brief: 'Warns when identifier name length very short or long.',
          ),
          severity: readSeverity(config, Severity.warning),
          excludes: readExcludes(config),
        );

  @override
  Iterable<Issue> check(InternalResolvedUnitResult source) {
    final issues = <Issue>[];
    final visitor = _Visitor();
    final validator = CorrectIdentifierLengthValidator(
      _maxLength,
      _minLength,
      _exceptions,
    );

    source.unit.visitChildren(visitor);

    for (final element in visitor.node) {
      final message = validator.getMessage<VariableDeclaration>(element);
      if (message != null) {
        issues.add(createIssue(
          rule: this,
          location: nodeLocation(
            node: element.name,
            source: source,
            withCommentOrMetadata: true,
          ),
          message: message,
        ));
      }
    }

    return issues;
  }
}
