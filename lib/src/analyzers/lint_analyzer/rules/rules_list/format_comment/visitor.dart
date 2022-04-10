part of 'format_comment_rule.dart';

const commentsOperator = {
  _CommentType.base: '//',
  _CommentType.documentation: '///',
};

class _Visitor extends RecursiveAstVisitor<void> {
  final _comments = <_CommentInfo>[];

  Iterable<_CommentInfo> get comments => _comments;

  void checkComments(AstNode node) {
    Token? token = node.beginToken;
    while (token != null) {
      Token? commentToken = token.precedingComments;
      while (commentToken != null) {
        _commentValidation(commentToken);
        commentToken = commentToken.next;
      }

      if (token == token.next) {
        break;
      }

      token = token.next;
    }
  }

  void _commentValidation(Token commentToken) {
    if (commentToken.type == TokenType.SINGLE_LINE_COMMENT) {
      final token = commentToken.toString();
      if (token.startsWith('///')) {
        _checkCommentByType(commentToken, _CommentType.documentation);
      } else if (token.startsWith('//')) {
        _checkCommentByType(commentToken, _CommentType.base);
      }
    }
  }

  void _checkCommentByType(Token commentToken, _CommentType type) {
    final commentText =
        commentToken.toString().substring(commentsOperator[type]!.length);

    var text = commentText.trim();

    if (text.isEmpty ||
        text.startsWith('ignore:') ||
        text.startsWith('ignore_for_file:')) {
      return;
    } else {
      text = text.trim();
      final upperCase = text[0] == text[0].toUpperCase();
      final lastSymbol = _punctuation.contains(text[text.length - 1]);
      final hasEmptySpace = commentText[0] == ' ';
      final incorrectFormat = !upperCase || !hasEmptySpace || !lastSymbol;
      final single = commentToken.previous == null && commentToken.next == null;

      if (incorrectFormat && single) {
        _comments.add(_CommentInfo(type, commentToken));
      }
    }
  }
}
