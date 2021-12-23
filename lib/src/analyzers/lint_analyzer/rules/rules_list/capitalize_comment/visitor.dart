part of 'capitalize_comment_rule.dart';

const commentsOperator = ['//', '///', '/*'];

class _Visitor extends RecursiveAstVisitor<void> {
  final _comments = <CommentInfo>[];

  Iterable<CommentInfo> get comments => _comments;

  void visitComments(AstNode node) {
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
    var type = '';
    if (comment.startsWith('//')) {
      type = '//';
    }
    if (comment.startsWith('///')) {
      type = '///';
    }
    if (comment.startsWith('/*')) {
      type = '/*';
    }

    final length = type == '/*' ? comment.length - 2 : comment.length;

    final message = comment.substring(type.length, length);
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
