part of 'prefer_commenting_analyzer_ignores.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final LineInfo _lineInfo;

  final _comments = <Token>[];

  Iterable<Token> get comments => _comments;

  _Visitor(this._lineInfo);

  void checkComments(AstNode node) {
    Token? token = node.beginToken;
    while (token != null) {
      Token? commentToken = token.precedingComments;
      while (commentToken != null) {
        _visitCommentToken(commentToken);
        commentToken = commentToken.next;
      }

      if (token == token.next) {
        break;
      }

      token = token.next;
    }
  }

  void _visitCommentToken(Token node) {
    if (node.type == TokenType.SINGLE_LINE_COMMENT) {
      final comment = node.toString();

      if (_isIgnoreComment(comment) &&
          _hasNoDescription(comment) &&
          _hasNoPreviousComment(node)) {
        _comments.add(node);
      }
    }
  }

  bool _isIgnoreComment(String comment) {
    final regExp = RegExp(r'(^//\s*ignore:\s*)', multiLine: true);

    return regExp.allMatches(comment).isNotEmpty;
  }

  bool _hasNoDescription(String comment) {
    final regExp = RegExp(r'(^//\s*ignore:.+?[^,\s]\s)', multiLine: true);

    return regExp.allMatches(comment).isEmpty;
  }

  bool _hasNoPreviousComment(Token node) {
    final previous = node.previous;

    return previous == null ||
        ((previous.type != TokenType.SINGLE_LINE_COMMENT ||
                previous.toString().startsWith('///')) ||
            _lineInfo.getLocation(node.offset).lineNumber - 1 !=
                _lineInfo.getLocation(previous.offset).lineNumber);
  }
}
