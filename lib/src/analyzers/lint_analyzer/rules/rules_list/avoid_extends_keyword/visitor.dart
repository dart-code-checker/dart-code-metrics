part of 'avoid_extends_keyword_rule.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final _expressions = <ClassDeclaration>[];

  Iterable<ClassDeclaration> get expressions => _expressions;

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    final beginTokenType = node.parent?.beginToken.type;
    final keywordType = node.extendsClause?.extendsKeyword.type;

    if (beginTokenType == Keyword.ABSTRACT && keywordType == Keyword.EXTENDS) {
      _expressions.add(node);
    }
  }
}
