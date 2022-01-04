part of 'format_comment_rule.dart';

const commentsOperator = {
  CommentType.base: '//',
  CommentType.documentation: '///',
  CommentType.multiline: '/*',
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
    final comment = commentToken.toString();
    var type = CommentType.base;
    if (comment.startsWith('//')) {
      type = CommentType.base;
    }
    if (comment.startsWith('///')) {
      type = CommentType.documentation;
    }
    if (comment.startsWith('/*')) {
      type = CommentType.multiline;
    }

    final length =
        type == CommentType.multiline ? comment.length - 2 : comment.length;

    final message = comment.substring(commentsOperator[type]!.length, length);
    final messageTrim = message.trim();
    final firstLetter = messageTrim[0];
    final isFirstLetterUppercase = firstLetter == firstLetter.toUpperCase();
    final isFirstLetterSpace = message[0] == ' ';
    final lastSymbol = messageTrim[messageTrim.length - 1];
    final lastPunctuation = _punctuation.contains(lastSymbol);

    if (message.isNotEmpty &&
        (!isFirstLetterUppercase || !isFirstLetterSpace || !lastPunctuation)) {
      _comments.add(CommentInfo(type, commentToken));
    }
  }
}
