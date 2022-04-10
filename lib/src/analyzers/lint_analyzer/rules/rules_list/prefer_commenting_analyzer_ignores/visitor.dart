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

      final matches = _getIgnoreMatches(comment);
      if (_hasNoDescription(matches, comment) && _hasNoPreviousComment(node)) {
        _comments.add(node);
      }
    }
  }

  bool _hasNoDescription(Iterable<Match> matches, String comment) =>
      matches.isNotEmpty &&
      matches.first.groupCount > 0 &&
      comment.trim().endsWith(matches.first.group(0)?.trim() ?? '');

  bool _hasNoPreviousComment(Token node) {
    final previous = node.previous;

    return previous == null ||
        (previous.type != TokenType.SINGLE_LINE_COMMENT ||
            _lineInfo.getLocation(node.offset).lineNumber - 1 !=
                _lineInfo.getLocation(previous.offset).lineNumber);
  }

  Iterable<Match> _getIgnoreMatches(String comment) {
    final regExp = RegExp(r'ignore:[a-z_,-\s]*([a-z]*(-|_)[a-z]*)+');

    return regExp.allMatches(comment);
  }
}
