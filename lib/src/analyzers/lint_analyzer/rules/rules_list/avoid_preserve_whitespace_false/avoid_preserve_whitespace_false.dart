import 'package:analyzer/dart/ast/ast.dart';
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

class AvoidPreserveWhitespaceFalseRule extends Rule {
  static const String ruleId = 'avoid-preserve-whitespace-false';

  static const _warning = 'Avoid using preserveWhitespace: false.';

  AvoidPreserveWhitespaceFalseRule([Map<String, Object> config = const {}])
      : super(
          id: ruleId,
          documentation: const RuleDocumentation(
            name: 'Avoid preserve whitespace false',
            brief:
                'Warns when a @Component annotation has explicit false value for preserveWhitespace.',
          ),
          severity: readSeverity(config, Severity.warning),
          excludes: readExcludes(config),
        );

  @override
  Iterable<Issue> check(InternalResolvedUnitResult source) {
    final visitor = _Visitor();

    source.unit.visitChildren(visitor);

    return visitor.expression
        .map((expression) => createIssue(
              rule: this,
              location: nodeLocation(
                node: expression,
                source: source,
                withCommentOrMetadata: true,
              ),
              message: _warning,
            ))
        .toList(growable: false);
  }
}
