part of 'technical_debt_metric.dart';

final _todoRegExp = RegExp(r'//+(.* )?TODO\b');
final _hacksRegExp = RegExp(r'//+(.* )?HACK\b');
final _fixmeRegExp = RegExp(r'//+(.* )?FIXME\b');
final _undoneRegExp = RegExp(r'//+(.* )?UNDONE\b');

final _ignorePattern = RegExp('// *ignore:');

final _ignoreForFilePattern = RegExp('// *ignore_for_file:');

class _Visitor extends RecursiveAstVisitor<void> {
  final _todoComments = <Token>[];
  final _ignoreComments = <Token>[];
  final _ignoreForFileComments = <Token>[];
  final _nonNullSafetyLanguageComment = <Token>[];
  final _asDynamicExpressions = <AsExpression>[];
  final _deprecatedAnnotations = <Annotation>[];

  Iterable<Token> get todos => _todoComments;
  Iterable<Token> get ignore => _ignoreComments;
  Iterable<Token> get ignoreForFile => _ignoreForFileComments;
  Iterable<Token> get nonNullSafetyLanguageComment =>
      _nonNullSafetyLanguageComment;
  Iterable<AsExpression> get asDynamicExpressions => _asDynamicExpressions;
  Iterable<Annotation> get deprecatedAnnotations => _deprecatedAnnotations;

  void visitComments(AstNode node) {
    Token? token = node.beginToken;
    while (token != null) {
      Token? comment = token.precedingComments;
      while (comment != null) {
        final content = comment.lexeme;
        if (content.startsWith(_todoRegExp) ||
            content.startsWith(_hacksRegExp) ||
            content.startsWith(_fixmeRegExp) ||
            content.startsWith(_undoneRegExp)) {
          _todoComments.add(comment);
        } else if (content.startsWith(_ignorePattern)) {
          _ignoreComments.add(comment);
        } else if (content.startsWith(_ignoreForFilePattern)) {
          _ignoreForFileComments.add(comment);
        } else if (comment is LanguageVersionToken) {
          final nullSafetyFile =
              comment.major > 2 || (comment.major == 2 && comment.minor >= 12);
          if (!nullSafetyFile) {
            _nonNullSafetyLanguageComment.add(comment);
          }
        }

        comment = comment.next;
      }

      if (token == token.next) {
        break;
      }

      token = token.next;
    }
  }

  @override
  void visitAsExpression(AsExpression node) {
    super.visitAsExpression(node);

    if (node.type.type is DynamicType) {
      _asDynamicExpressions.add(node);
    }
  }

  @override
  void visitAnnotation(Annotation node) {
    super.visitAnnotation(node);

    final elementAnnotation = node.elementAnnotation;
    if (elementAnnotation != null && elementAnnotation.isDeprecated) {
      _deprecatedAnnotations.add(node);
    }
  }
}
