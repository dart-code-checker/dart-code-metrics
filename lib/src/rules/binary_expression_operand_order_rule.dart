import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';

import '../models/code_issue.dart';
import '../models/code_issue_severity.dart';
import '../models/source.dart';
import 'base_rule.dart';
import 'rule_utils.dart';

class BinaryExpressionOperandOrderRule extends BaseRule {
  static const String ruleId = 'binary-expression-operand-order';
  static const _documentationUrl = 'https://git.io/JJVAC';

  static const _warningMessage = 'Prefer literals at RHS in binary expressions';
  static const _correctionComment = 'Fix operator order';

  BinaryExpressionOperandOrderRule({Map<String, Object> config = const {}})
      : super(
          id: ruleId,
          documentation: Uri.parse(_documentationUrl),
          severity: CodeIssueSeverity.fromJson(config['severity'] as String) ??
              CodeIssueSeverity.style,
        );

  @override
  Iterable<CodeIssue> check(Source source) {
    final visitor = _Visitor();

    source.compilationUnit.visitChildren(visitor);

    return visitor.binaryExpressions
        .map((lit) => createIssue(
              this,
              _warningMessage,
              '${lit.rightOperand} ${lit.operator} ${lit.leftOperand}',
              _correctionComment,
              source.url,
              source.content,
              source.compilationUnit.lineInfo,
              lit,
            ))
        .toList(growable: false);
  }
}

class _Visitor extends RecursiveAstVisitor<void> {
  final _binaryExpressions = <BinaryExpression>[];

  Iterable<BinaryExpression> get binaryExpressions => _binaryExpressions;

  @override
  void visitBinaryExpression(BinaryExpression e) {
    if (_supportedLeftOperand(e.leftOperand) &&
        _supportedRightOperand(e.rightOperand) &&
        _supportedOperator(e.operator)) {
      _binaryExpressions.add(e);
    }
    super.visitBinaryExpression(e);
  }

  bool _supportedLeftOperand(Expression operand) =>
      operand is IntegerLiteral || operand is DoubleLiteral;

  bool _supportedRightOperand(Expression operand) => operand is Identifier;

  bool _supportedOperator(Token operator) =>
      operator.type == TokenType.PLUS ||
      operator.type == TokenType.STAR ||
      operator.type == TokenType.AMPERSAND ||
      operator.type == TokenType.BAR ||
      operator.type == TokenType.CARET;
}
