// ignore_for_file: public_member_api_docs

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';

import '../../../../../utils/node_utils.dart';
import '../../../lint_utils.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/issue.dart';
import '../../../models/severity.dart';
import '../../models/common_rule.dart';
import '../../rule_utils.dart';
import '../common_config.dart';

part 'config_parser.dart';
part 'visitor.dart';

class PreferStaticClassRule extends CommonRule {
  static const String ruleId = 'prefer-static-class';

  static const _warningMessage =
      'Prefer declaring static class members instead of global functions, variables and constants.';

  final bool _ignorePrivate;
  final Iterable<String> _ignoreNames;
  final Iterable<String> _ignoreAnnotations;

  PreferStaticClassRule([Map<String, Object> config = const {}])
      : _ignorePrivate = _ConfigParser.parseIgnorePrivate(config),
        _ignoreAnnotations = _ConfigParser.parseIgnoreAnnotations(config),
        _ignoreNames = _ConfigParser.parseIgnoreNames(config),
        super(
          id: ruleId,
          severity: readSeverity(config, Severity.style),
          excludes: readExcludes(config),
          includes: readIncludes(config),
        );

  @override
  Map<String, Object?> toJson() {
    final json = super.toJson();
    json[_ConfigParser._ignorePrivate] = _ignorePrivate;
    json[_ConfigParser._ignoreNames] = _ignoreNames.toList();
    json[_ConfigParser._ignoreAnnotations] = _ignoreAnnotations.toList();

    return json;
  }

  @override
  Iterable<Issue> check(InternalResolvedUnitResult source) {
    final visitor = _Visitor(
      ignorePrivate: _ignorePrivate,
      ignoreNames: _ignoreNames,
      ignoreAnnotations: _ignoreAnnotations,
    );

    source.unit.visitChildren(visitor);

    return visitor.declarations
        .map((declaration) => createIssue(
              rule: this,
              location: nodeLocation(
                node: declaration,
                source: source,
              ),
              message: _warningMessage,
            ))
        .toList(growable: false);
  }
}
