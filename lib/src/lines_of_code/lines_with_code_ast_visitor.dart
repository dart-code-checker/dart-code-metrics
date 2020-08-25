import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/source/line_info.dart';

class LinesWithCodeAstVisitor extends RecursiveAstVisitor<Object> {
  final LineInfo _lineInfo;

  final _linesWithCode = <int>{};
  Iterable<int> get linesWithCode => _linesWithCode;

  LinesWithCodeAstVisitor(this._lineInfo);

  @override
  void visitBlockFunctionBody(BlockFunctionBody node) {
    _collectFunctionBodyData(
        node.block.leftBracket.next, node.block.rightBracket);
    super.visitBlockFunctionBody(node);
  }

  @override
  void visitExpressionFunctionBody(ExpressionFunctionBody node) {
    _collectFunctionBodyData(
        node.expression.beginToken.previous, node.expression.endToken.next);
    super.visitExpressionFunctionBody(node);
  }

  void _collectFunctionBodyData(Token firstToken, Token lastToken) {
    var token = firstToken;
    while (token != lastToken) {
      _linesWithCode.add(_lineInfo.getLocation(token.offset).lineNumber);
      token = token.next;
    }
  }
}
