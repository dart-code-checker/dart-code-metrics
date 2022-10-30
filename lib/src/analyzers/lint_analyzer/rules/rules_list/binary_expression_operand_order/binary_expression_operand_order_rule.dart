// ignore_for_file: public_member_api_docs

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';

import '../../../../../utils/node_utils.dart';
import '../../../lint_utils.dart';
import '../../../models/internal_resolved_unit_result.dart';
import '../../../models/issue.dart';
import '../../../models/replacement.dart';
import '../../../models/severity.dart';
import '../../models/common_rule.dart';
import '../../rule_utils.dart';

part 'visitor.dart';

class BinaryExpressionOperandOrderRule extends CommonRule {
  static const String ruleId = 'binary-expression-operand-order';

  static const _warningMessage =
      'Prefer literals at RHS in binary expressions.';
  static const _correctionComment = 'Fix operator order.';

  BinaryExpressionOperandOrderRule([Map<String, Object> config = const {}])
      : super(
          id: ruleId,
          severity: readSeverity(config, Severity.style),
          excludes: readExcludes(config),
          includes: readIncludes(config),
        );

  @override
  Iterable<Issue> check(InternalResolvedUnitResult source) {
    final visitor = _Visitor();

    source.unit.visitChildren(visitor);

    return visitor.binaryExpressions
        .map((lit) => createIssue(
              rule: this,
              location: nodeLocation(node: lit, source: source),
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
