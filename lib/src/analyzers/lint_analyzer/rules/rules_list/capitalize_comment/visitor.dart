part of 'capitalize_comment_rule.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final _comments = <Token>[];

  Iterable<Token> get comments => _comments;

  void visitComments(AstNode node) {
    Token? token = node.beginToken;
    while (token != null) {
      Token? comment = token.precedingComments;
      while (comment != null) {
        // TODO(konoshenko): Filter comments here.
        _comments.add(comment);
        comment = comment.next;
      }

      if (token == token.next) {
        break;
      }

      token = token.next;
    }
  }
}
