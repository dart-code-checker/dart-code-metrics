class SomeClass {
  final _addedComments = <Token>{};

  Token? _latestCommentToken(Token token) {
    Token? latestCommentToken = token.precedingComments;
    while (latestCommentToken?.next != null) {
      latestCommentToken = latestCommentToken?.next;
    }

    return latestCommentToken;
  }

  void method(Token token) {
    Token? commentToken = token.precedingComments;

    if (commentToken != null && !_addedComments.contains(commentToken)) {
      if (!fromEnd) {
        sink.write('\n');
      }
    }

    while (commentToken != null) {
      if (_addedComments.contains(commentToken)) {
        commentToken = commentToken.next;
        continue;
      }
      _addedComments.add(commentToken);
    }
  }
}

class Token {
  final Token precedingComments;

  const Token(this.precedingComments);
}
