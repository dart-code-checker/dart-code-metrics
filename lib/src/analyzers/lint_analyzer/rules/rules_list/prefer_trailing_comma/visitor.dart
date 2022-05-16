part of 'prefer_trailing_comma_rule.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final LineInfo _lineInfo;
  final int? _breakpoint;

  final _nodes = <AstNode>[];

  Iterable<AstNode> get nodes => _nodes;

  _Visitor(this._lineInfo, this._breakpoint);

  @override
  void visitArgumentList(ArgumentList node) {
    super.visitArgumentList(node);

    _visitNodeList(node.arguments, node.leftParenthesis, node.rightParenthesis);
  }

  @override
  void visitFormalParameterList(FormalParameterList node) {
    super.visitFormalParameterList(node);

    _visitNodeList(
      node.parameters,
      node.leftParenthesis,
      node.rightParenthesis,
    );
  }

  @override
  void visitListLiteral(ListLiteral node) {
    super.visitListLiteral(node);

    _visitNodeList(node.elements, node.leftBracket, node.rightBracket);
  }

  @override
  void visitSetOrMapLiteral(SetOrMapLiteral node) {
    super.visitSetOrMapLiteral(node);

    _visitNodeList(node.elements, node.leftBracket, node.rightBracket);
  }

  void _visitNodeList(
    Iterable<AstNode> nodes,
    Token leftBracket,
    Token rightBracket,
  ) {
    if (nodes.isEmpty) {
      return;
    }

    final last = nodes.last;

    if (last.endToken.next?.type != TokenType.COMMA &&
        (!_isLastItemMultiLine(last, leftBracket, rightBracket) &&
                _getLineNumber(leftBracket) != _getLineNumber(rightBracket) ||
            _breakpoint != null && nodes.length >= _breakpoint!)) {
      _nodes.add(last);
    }
  }

  bool _isLastItemMultiLine(
    AstNode node,
    Token leftBracket,
    Token rightBracket,
  ) =>
      _getLineNumber(leftBracket) ==
          _lineInfo.getLocation(node.offset).lineNumber &&
      _getLineNumber(rightBracket) ==
          _lineInfo.getLocation(node.end).lineNumber;

  int _getLineNumber(SyntacticEntity entity) =>
      _lineInfo.getLocation(entity.offset).lineNumber;
}
