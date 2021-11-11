part of 'no_magic_number_rule.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final _literals = <Literal>[];

  Iterable<Literal> get literals => _literals;

  @override
  void visitDoubleLiteral(DoubleLiteral node) {
    _literals.add(node);
    super.visitDoubleLiteral(node);
  }

  @override
  void visitIntegerLiteral(IntegerLiteral node) {
    _literals.add(node);
    super.visitIntegerLiteral(node);
  }
}
