import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:dart_code_metrics/src/models/code_issue.dart';
import 'package:dart_code_metrics/src/models/code_issue_severity.dart';

import 'base_rule.dart';
import 'rule_utils.dart';

class BinaryExpressionOperandOrderRule extends BaseRule {
  static const _warningMessage = 'Prefer literals at RHS in binary expressions';
  static const _correctionComment = 'Fix operator order';

  const BinaryExpressionOperandOrderRule()
      : super(
            id: 'binary-expression-operand-order',
            severity: CodeIssueSeverity.style);

  @override
  Iterable<CodeIssue> check(
      CompilationUnit unit, Uri sourceUrl, String sourceContent) {
    final visitor = _Visitor();

    unit.visitChildren(visitor);

    return visitor.binaryExpressions
        .map((lit) => createIssue(
            this,
            _warningMessage,
            '${lit.rightOperand} ${lit.operator} ${lit.leftOperand}',
            _correctionComment,
            sourceUrl,
            sourceContent,
            unit.lineInfo,
            lit))
        .toList(growable: false);
  }
}

class _Visitor extends RecursiveAstVisitor<Object> {
  final _binaryExpressions = <BinaryExpression>[];

  Iterable<BinaryExpression> get binaryExpressions => _binaryExpressions;

  @override
  void visitBinaryExpression(BinaryExpression e) {
    if ((e.leftOperand is IntegerLiteral || e.leftOperand is DoubleLiteral) &&
        e.rightOperand is Identifier) {
      _binaryExpressions.add(e);
    }
    super.visitBinaryExpression(e);
  }
}
