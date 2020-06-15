import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/syntactic_entity.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/source/line_info.dart';

import 'cyclomatic_config.dart';

class ControlFlowAstVisitor extends RecursiveAstVisitor<Object> {
  final CyclomaticConfig _config;
  final LineInfo _lineInfo;

  final _complexityLines = <int, int>{};

  ControlFlowAstVisitor(this._config, this._lineInfo);

  Map<int, int> get complexityLines => _complexityLines;

  @override
  void visitAssertStatement(AssertStatement node) {
    _increaseComplexity('assertStatement', node);
    super.visitAssertStatement(node);
  }

  @override
  void visitBlockFunctionBody(BlockFunctionBody node) {
    _collectFunctionBodyData(
        node.block.leftBracket.next, node.block.rightBracket);
    super.visitBlockFunctionBody(node);
  }

  @override
  void visitCatchClause(CatchClause node) {
    _increaseComplexity('catchClause', node);
    super.visitCatchClause(node);
  }

  @override
  void visitConditionalExpression(ConditionalExpression node) {
    _increaseComplexity('conditionalExpression', node);
    super.visitConditionalExpression(node);
  }

  @override
  void visitExpressionFunctionBody(ExpressionFunctionBody node) {
    _collectFunctionBodyData(
        node.expression.beginToken.previous, node.expression.endToken.next);
    node.visitChildren(this);
  }

  @override
  void visitForStatement(ForStatement node) {
    _increaseComplexity('forStatement', node);
    super.visitForStatement(node);
  }

  @override
  void visitIfStatement(IfStatement node) {
    _increaseComplexity('ifStatement', node);
    super.visitIfStatement(node);
  }

  @override
  void visitSwitchCase(SwitchCase node) {
    _increaseComplexity('switchCase', node);
    super.visitSwitchCase(node);
  }

  @override
  void visitSwitchDefault(SwitchDefault node) {
    _increaseComplexity('switchDefault', node);
    super.visitSwitchDefault(node);
  }

  @override
  void visitWhileStatement(WhileStatement node) {
    _increaseComplexity('whileStatement', node);
    super.visitWhileStatement(node);
  }

  @override
  void visitYieldStatement(YieldStatement node) {
    _increaseComplexity('yieldStatement', node);
    super.visitYieldStatement(node);
  }

  void _collectFunctionBodyData(Token firstToken, Token lastToken) {
    const tokenTypes = [
      TokenType.AMPERSAND_AMPERSAND,
      TokenType.BAR_BAR,
      TokenType.QUESTION_PERIOD,
      TokenType.QUESTION_QUESTION,
      TokenType.QUESTION_QUESTION_EQ,
    ];

    var token = firstToken;
    while (token != lastToken) {
      if (token.matchesAny(tokenTypes)) {
        _increaseComplexity('blockFunctionBody', token);
      }
      token = token.next;
    }
  }

  void _increaseComplexity(String flowType, SyntacticEntity entity) {
    final entityComplexity = _config.complexityByControlFlowType(flowType);
    final entityLineNumber = _lineInfo.getLocation(entity.offset).lineNumber;
    _complexityLines[entityLineNumber] =
        (_complexityLines[entityLineNumber] ?? 0) + entityComplexity;
  }
}
