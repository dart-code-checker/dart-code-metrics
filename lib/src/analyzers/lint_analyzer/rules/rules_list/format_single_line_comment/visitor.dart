part of 'format_single_line_comment_rule.dart';

const commentsOperator = {
  CommentType.base: '//',
  CommentType.documentation: '///',
};

class _Visitor extends RecursiveAstVisitor<void> {
  final _comments = <CommentInfo>[];

  Iterable<CommentInfo> get comments => _comments;

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
      if (commentToken.toString().startsWith('///')) {
        _checkCommentByType(commentToken, CommentType.documentation);
      } else if (commentToken.toString().startsWith('//')) {
        _checkCommentByType(commentToken, CommentType.base);
      }
    }
  }

  void _checkCommentByType(Token commentToken, CommentType type) {
    final commentText = commentToken.toString();
    var text = commentText.substring(commentsOperator[type]!.length);

    if (text.isEmpty ||
        text.startsWith(' ignore:') ||
        text.startsWith(' ignore_for_file:')) {
      return;
    } else {
      text = text.trim();
      final upperCase = text[0] == text[0].toUpperCase();
      final hasEmptySpace = text.startsWith(' ');
      final lastSymbol = _punctuation.contains(text[text.length - 1]);

      final incorrectFormat = !upperCase || !hasEmptySpace || !lastSymbol;
      final single = commentToken.previous == null && commentToken.next == null;

      if (incorrectFormat && single) {
        _comments.add(CommentInfo(type, commentToken));
      }
    }
  }
}
