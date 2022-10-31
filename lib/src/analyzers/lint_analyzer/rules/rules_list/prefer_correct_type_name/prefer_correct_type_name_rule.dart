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

class PreferCorrectTypeNameRule extends CommonRule {
  static const String ruleId = 'prefer-correct-type-name';
  final _Validator _validator;

  PreferCorrectTypeNameRule([Map<String, Object> config = const {}])
      : _validator = _Validator(
          maxLength: _ConfigParser.readMaxTypeLength(config),
          minLength: _ConfigParser.readMinTypeLength(config),
          exceptions: _ConfigParser.readExcludes(config),
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
    json[_minTypeLengthLabel] = _validator.minLength;
    json[_maxTypeLengthLabel] = _validator.maxLength;
    json[_excludeLabel] = _validator.exceptions;

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
            message:
                "The '$node' name should only contain alphanumeric characters, start with an uppercase character and span between ${_validator.minLength} and ${_validator.maxLength} characters in length",
          ),
        )
        .toList(growable: false);
  }
}
