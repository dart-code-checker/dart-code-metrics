part of 'capitalize_comment_rule.dart';

class _Visitor extends SimpleAstVisitor<void> {
  final _declarations = <AstNode>[];

  Iterable<AstNode> get declarations => _declarations;

  static final _todoRegExp = RegExp(r'//+(.* )?TODO\b');

  static final _todoExpectedRegExp =
      RegExp(r'// TODO\([a-zA-Z][-a-zA-Z0-9]*\): ');

  @override
  void visitCompilationUnit(CompilationUnit node) {
    Token? token = node.beginToken;
    while (token != null) {
      _getPrecedingComments(token).forEach((e) => _visitComment(node, e));
      if (token == token.next) break;
      token = token.next;
    }
  }

  Iterable<Token> _getPrecedingComments(Token token) sync* {
    Token? comment = token.precedingComments;
    while (comment != null) {
      yield comment;
      comment = comment.next;
    }
  }

  void _visitComment(AstNode node, Token token) {
    var content = token.lexeme;
    if (content.startsWith(_todoRegExp) &&
        !content.startsWith(_todoExpectedRegExp)) {
      _declarations.add(node);
    }
  }
}
