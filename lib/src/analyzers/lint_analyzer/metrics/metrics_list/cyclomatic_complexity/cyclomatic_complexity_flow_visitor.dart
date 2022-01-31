// ignore_for_file: public_member_api_docs

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/syntactic_entity.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';

/// The AST visitor that will collect cyclomatic complexity of visit nodes in an AST structure.
class CyclomaticComplexityFlowVisitor extends RecursiveAstVisitor<void> {
  static const _complexityTokenTypes = [
    TokenType.AMPERSAND_AMPERSAND,
    TokenType.BAR_BAR,
    TokenType.QUESTION_PERIOD,
    TokenType.QUESTION_QUESTION,
    TokenType.QUESTION_QUESTION_EQ,
  ];

  final _complexityEntities = <SyntacticEntity>{};

  /// Returns an array of entities that increase cyclomatic complexity.
  Iterable<SyntacticEntity> get complexityEntities => _complexityEntities;

  @override
  void visitAssertStatement(AssertStatement node) {
    _increaseComplexity(node);

    super.visitAssertStatement(node);
  }

  @override
  void visitBlockFunctionBody(BlockFunctionBody node) {
    _visitBlock(
      node.block.leftBracket.next,
      node.block.rightBracket,
    );

    super.visitBlockFunctionBody(node);
  }

  @override
  void visitCatchClause(CatchClause node) {
    _increaseComplexity(node);

    super.visitCatchClause(node);
  }

  @override
  void visitConditionalExpression(ConditionalExpression node) {
    _increaseComplexity(node);

    super.visitConditionalExpression(node);
  }

  @override
  void visitExpressionFunctionBody(ExpressionFunctionBody node) {
    _visitBlock(
      node.expression.beginToken.previous,
      node.expression.endToken.next,
    );

    super.visitExpressionFunctionBody(node);
  }

  @override
  void visitForStatement(ForStatement node) {
    _increaseComplexity(node);

    super.visitForStatement(node);
  }

  @override
  void visitIfStatement(IfStatement node) {
    _increaseComplexity(node);

    super.visitIfStatement(node);
  }

  @override
  void visitSwitchCase(SwitchCase node) {
    _increaseComplexity(node);

    super.visitSwitchCase(node);
  }

  @override
  void visitSwitchDefault(SwitchDefault node) {
    _increaseComplexity(node);

    super.visitSwitchDefault(node);
  }

  @override
  void visitWhileStatement(WhileStatement node) {
    _increaseComplexity(node);

    super.visitWhileStatement(node);
  }

  @override
  void visitYieldStatement(YieldStatement node) {
    _increaseComplexity(node);

    super.visitYieldStatement(node);
  }

  void _visitBlock(Token? firstToken, Token? lastToken) {
    var token = firstToken;
    while (token != lastToken && token != null) {
      if (token.matchesAny(_complexityTokenTypes)) {
        _increaseComplexity(token);
      }

      token = token.next;
    }
  }

  void _increaseComplexity(SyntacticEntity entity) {
    _complexityEntities.add(entity);
  }
}
