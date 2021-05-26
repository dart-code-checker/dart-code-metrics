part of 'double_literal_format.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final _literals = <DoubleLiteral>[];

  Iterable<DoubleLiteral> get literals => _literals;

  @override
  void visitDoubleLiteral(DoubleLiteral node) {
    _literals.add(node);

    super.visitDoubleLiteral(node);
  }
}
