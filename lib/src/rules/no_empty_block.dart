import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:dart_code_metrics/src/models/code_issue.dart';
import 'package:dart_code_metrics/src/models/code_issue_severity.dart';

import 'base_rule.dart';
import 'rule_utils.dart';

// Inspired by TSLint (https://palantir.github.io/tslint/rules/no-empty/)

class NoEmptyBlockRule extends BaseRule {
  static const _failure =
      'Block is empty. Empty blocks are often indicators of missing code.';

  const NoEmptyBlockRule()
      : super(
          id: 'no-empty-block',
          severity: CodeIssueSeverity.style,
        );

  @override
  Iterable<CodeIssue> check(
      CompilationUnit unit, Uri sourceUrl, String sourceContent) {
    final _visitor = _Visitor();

    unit.visitChildren(_visitor);

    return _visitor.emptyBlocks
        .map((block) => createIssue(this, _failure, null, null, sourceUrl,
            sourceContent, unit.lineInfo, block))
        .toList(growable: false);
  }
}

class _Visitor extends RecursiveAstVisitor<Object> {
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
