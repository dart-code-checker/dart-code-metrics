part of 'avoid_preserve_whitespace_false_rule.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final _expression = <NamedExpression>[];

  Iterable<NamedExpression> get expression => _expression;

  @override
  void visitAnnotation(Annotation node) {
    if (node.name.name == 'Component' &&
        node.atSign.type == TokenType.AT &&
        node.parent is ClassDeclaration) {
      final preserveWhitespaceArg = node.arguments?.arguments
          .whereType<NamedExpression>()
          .firstWhereOrNull(
            (arg) => arg.name.label.name == 'preserveWhitespace',
          );
      if (preserveWhitespaceArg != null) {
        final expression = preserveWhitespaceArg.expression;
        if (expression is BooleanLiteral &&
            expression.literal.keyword == Keyword.FALSE) {
          _expression.add(preserveWhitespaceArg);
        }
      }
    }
  }
}
