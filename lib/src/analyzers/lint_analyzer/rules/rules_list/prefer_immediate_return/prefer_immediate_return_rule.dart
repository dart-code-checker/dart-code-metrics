// ignore_for_file: public_member_api_docs

import 'package:analyzer/dart/ast/ast.dart';
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

class PreferImmediateReturnRule extends CommonRule {
  static const ruleId = 'prefer-immediate-return';
  static const _warningMessage =
      'Prefer returning the result immediately instead of declaring an intermediate variable right before the return statement.';
  static const _replaceComment = 'Replace with immediate return.';

  PreferImmediateReturnRule([Map<String, Object> config = const {}])
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

    return visitor.issues.map(
      (issue) {
        AstNode? getSingleDeclarationNode() {
          final declarationList =
              issue.variableDeclaration.parent as VariableDeclarationList;

          return declarationList.variables.length == 1 ? declarationList : null;
        }

        return createIssue(
          rule: this,
          location: nodeLocation(
            node: getSingleDeclarationNode() ?? issue.returnStatement,
            endNode: issue.returnStatement,
            source: source,
          ),
          message: _warningMessage,
          replacement: Replacement(
            comment: _replaceComment,
            replacement: 'return ${issue.variableDeclaration.initializer};',
          ),
        );
      },
    ).toList(growable: false);
  }
}
