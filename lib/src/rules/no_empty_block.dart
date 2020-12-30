import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:code_checker/rules.dart';

// Inspired by TSLint (https://palantir.github.io/tslint/rules/no-empty/)

class NoEmptyBlockRule extends Rule {
  static const String ruleId = 'no-empty-block';
  static const _documentationUrl = 'https://git.io/JfDi3';

  static const _failure =
      'Block is empty. Empty blocks are often indicators of missing code.';

  NoEmptyBlockRule({Map<String, Object> config = const {}})
      : super(
          id: ruleId,
          documentation: Uri.parse(_documentationUrl),
          severity: readSeverity(config, Severity.style),
        );

  @override
  Iterable<Issue> check(ProcessedFile file) {
    final _visitor = _Visitor();

    file.parsedContent.visitChildren(_visitor);

    return _visitor.emptyBlocks
        .map((block) =>
            createIssue(this, nodeLocation(block, file), _failure, null))
        .toList(growable: false);
  }
}

class _Visitor extends RecursiveAstVisitor<void> {
  final _emptyBlocks = <Block>[];

  Iterable<Block> get emptyBlocks => _emptyBlocks;

  @override
  void visitBlock(Block node) {
    super.visitBlock(node);

    if (node.statements.isEmpty &&
        node.parent is! CatchClause &&
        !(node.endToken.precedingComments?.lexeme?.contains('TODO') ?? false)) {
      _emptyBlocks.add(node);
    }
  }
}
