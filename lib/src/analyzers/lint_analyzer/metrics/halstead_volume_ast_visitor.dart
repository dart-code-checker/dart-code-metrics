import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';

class HalsteadVolumeAstVisitor extends RecursiveAstVisitor<void> {
  final _operators = <String, int>{};
  final _operands = <String, int>{};

  Map<String, int> get operators => _operators;
  Map<String, int> get operands => _operands;

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
    node.visitChildren(this);
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
