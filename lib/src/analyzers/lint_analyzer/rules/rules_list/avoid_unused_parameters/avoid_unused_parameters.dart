import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/syntactic_entity.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:collection/collection.dart';

import '../../../../../utils/node_utils.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/issue.dart';
import '../../../models/severity.dart';
import '../../models/rule.dart';
import '../../models/rule_documentation.dart';
import '../../rule_utils.dart';

part 'visitor.dart';

// Inspired by PVS-Studio (https://www.viva64.com/en/w/v6022/)

class AvoidUnusedParametersRule extends Rule {
  static const String ruleId = 'avoid-unused-parameters';

  static const _warningMessage = 'Parameter is unused.';

  AvoidUnusedParametersRule([Map<String, Object> config = const {}])
      : super(
          id: ruleId,
          documentation: const RuleDocumentation(
            name: 'Avoid unused parameters',
            brief:
                'Checks for unused parameters inside a function or method body.',
          ),
          severity: readSeverity(config, Severity.warning),
          excludes: readExcludes(config),
        );

  @override
  Iterable<Issue> check(InternalResolvedUnitResult source) {
    final _visitor = _Visitor();

    source.unit.visitChildren(_visitor);

    return _visitor.unusedParameters
        .map((parameter) => createIssue(
              rule: this,
              location: nodeLocation(
                node: parameter,
                source: source,
                withCommentOrMetadata: true,
              ),
              message: _warningMessage,
            ))
        .toList(growable: false);
  }
}
