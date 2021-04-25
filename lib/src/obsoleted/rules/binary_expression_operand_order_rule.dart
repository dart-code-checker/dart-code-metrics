import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';

import '../../models/issue.dart';
import '../../models/replacement.dart';
import '../../models/severity.dart';
import '../../utils/node_utils.dart';
import '../../utils/rule_utils.dart';
import 'obsolete_rule.dart';

class BinaryExpressionOperandOrderRule extends ObsoleteRule {
  static const String ruleId = 'binary-expression-operand-order';
  static const _documentationUrl = 'https://git.io/JJVAC';

  static const _warningMessage = 'Prefer literals at RHS in binary expressions';
  static const _correctionComment = 'Fix operator order';

  BinaryExpressionOperandOrderRule({Map<String, Object> config = const {}})
      : super(
          id: ruleId,
          documentationUrl: Uri.parse(_documentationUrl),
          severity: readSeverity(config, Severity.style),
          excludes: readExcludes(config),
        );

  @override
  Iterable<Issue> check(ResolvedUnitResult source) {
    final visitor = _Visitor();

    source.unit?.visitChildren(visitor);

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
