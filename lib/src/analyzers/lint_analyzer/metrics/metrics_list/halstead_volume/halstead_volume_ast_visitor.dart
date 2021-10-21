// ignore_for_file: public_member_api_docs

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:collection/collection.dart';

class HalsteadVolumeAstVisitor extends RecursiveAstVisitor<void> {
  final _operators = <String, int>{};
  final _operands = <String, int>{};

  /// the number of operators
  int get operators => _operators.values.sum;

  /// the number of unique operators
  int get uniqueOperators => _operators.keys.length;

  /// the number of operands
  int get operands => _operands.values.sum;

  /// the number of unique operands
  int get uniqueOperands => _operands.keys.length;

  @override
  void visitBlockFunctionBody(BlockFunctionBody node) {
    _analyzeFunctionBodyData(
      node.block.leftBracket.next,
      node.block.rightBracket,
    );

    super.visitBlockFunctionBody(node);
  }

  @override
  void visitExpressionFunctionBody(ExpressionFunctionBody node) {
    _analyzeFunctionBodyData(
      node.expression.beginToken.previous,
      node.expression.endToken.next,
    );

    super.visitExpressionFunctionBody(node);
  }

  void _analyzeFunctionBodyData(Token? firstToken, Token? lastToken) {
    var token = firstToken;
    while (token != lastToken && token != null) {
      if (token.isOperator) {
        _operators[token.type.name] = (_operators[token.type.name] ?? 0) + 1;
      }

      if (token.isIdentifier) {
        _operands[token.lexeme] = (_operands[token.lexeme] ?? 0) + 1;
      }

      token = token.next;
    }
  }
}
