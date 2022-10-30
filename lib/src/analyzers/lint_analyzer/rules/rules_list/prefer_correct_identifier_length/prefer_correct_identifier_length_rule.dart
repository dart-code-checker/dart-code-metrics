// ignore_for_file: public_member_api_docs

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';

import '../../../../../utils/node_utils.dart';
import '../../../lint_utils.dart';
import '../../../metrics/scope_visitor.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/issue.dart';
import '../../../models/severity.dart';
import '../../models/common_rule.dart';
import '../../rule_utils.dart';

part 'utils/config_parser.dart';
part 'validator.dart';
part 'visitor.dart';

class PreferCorrectIdentifierLengthRule extends CommonRule {
  static const String ruleId = 'prefer-correct-identifier-length';
  final _Validator _validator;

  PreferCorrectIdentifierLengthRule([Map<String, Object> config = const {}])
      : _validator = _Validator(
          maxLength: _ConfigParser.readMaxIdentifierLength(config),
          minLength: _ConfigParser.readMinIdentifierLength(config),
          exceptions: _ConfigParser.readExceptions(config),
        ),
        super(
          id: ruleId,
          severity: readSeverity(config, Severity.style),
          excludes: readExcludes(config),
          includes: readIncludes(config),
        );

  @override
  Map<String, Object?> toJson() {
    final json = super.toJson();
    json[_minIdentifierLengthLabel] = _validator.minLength;
    json[_maxIdentifierLengthLabel] = _validator.maxLength;
    json[_exceptionsLabel] = _validator.exceptions;

    return json;
  }

  @override
  Iterable<Issue> check(InternalResolvedUnitResult source) {
    final visitor = _Visitor(_validator);

    source.unit.visitChildren(visitor);

    return visitor.nodes
        .map(
          (node) => createIssue(
            rule: this,
            location: nodeLocation(node: node, source: source),
            message: createErrorMessage(node.lexeme),
          ),
        )
        .toList(growable: false);
  }

  String createErrorMessage(String name) => name.length > _validator.maxLength
      ? "The $name identifier is ${name.length} characters long. It's recommended to decrease it to ${_validator.maxLength} chars long."
      : "The $name identifier is ${name.length} characters long. It's recommended to increase it up to ${_validator.minLength} chars long.";
}
