part of 'no_empty_block.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final _emptyBlocks = <Block>[];

  Iterable<Block> get emptyBlocks => _emptyBlocks;

  @override
  void visitBlock(Block node) {
    super.visitBlock(node);

    if (node.statements.isEmpty &&
        node.parent is! CatchClause &&
        !(node.endToken.precedingComments?.lexeme.contains('TODO') ?? false)) {
      _emptyBlocks.add(node);
    }
  }
}
