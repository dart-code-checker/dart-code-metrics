import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';

import '../../../../../utils/node_utils.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/issue.dart';
import '../../../models/replacement.dart';
import '../../../models/severity.dart';
import '../../models/rule.dart';
import '../../models/rule_documentation.dart';
import '../../rule_utils.dart';

part 'visitor.dart';

class BinaryExpressionOperandOrderRule extends Rule {
  static const String ruleId = 'binary-expression-operand-order';

  static const _warningMessage =
      'Prefer literals at RHS in binary expressions.';
  static const _correctionComment = 'Fix operator order.';

  BinaryExpressionOperandOrderRule([Map<String, Object> config = const {}])
      : super(
          id: ruleId,
          documentation: const RuleDocumentation(
            name: 'Binary expression operand order',
            brief:
                'Warns when a literal value is on the left hand side in a binary expressions.',
          ),
          severity: readSeverity(config, Severity.style),
          excludes: readExcludes(config),
        );

  @override
  Iterable<Issue> check(InternalResolvedUnitResult source) {
    final visitor = _Visitor();

    source.unit.visitChildren(visitor);

    return visitor.binaryExpressions
        .map((lit) => createIssue(
              rule: this,
              location: nodeLocation(
                node: lit,
                source: source,
                withCommentOrMetadata: true,
              ),
              message: _warningMessage,
              replacement: Replacement(
                comment: _correctionComment,
                replacement:
                    '${lit.rightOperand} ${lit.operator} ${lit.leftOperand}',
              ),
            ))
        .toList(growable: false);
  }
}
