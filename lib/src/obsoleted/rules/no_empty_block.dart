import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

import '../../models/issue.dart';
import '../../models/severity.dart';
import '../../utils/node_utils.dart';
import '../../utils/rule_utils.dart';
import 'obsolete_rule.dart';

// Inspired by TSLint (https://palantir.github.io/tslint/rules/no-empty/)

class NoEmptyBlockRule extends ObsoleteRule {
  static const String ruleId = 'no-empty-block';
  static const _documentationUrl = 'https://git.io/JfDi3';

  static const _failure =
      'Block is empty. Empty blocks are often indicators of missing code.';

  NoEmptyBlockRule({Map<String, Object> config = const {}})
      : super(
          id: ruleId,
          documentationUrl: Uri.parse(_documentationUrl),
          severity: readSeverity(config, Severity.style),
        );

  @override
  Iterable<Issue> check(ResolvedUnitResult source) {
    final _visitor = _Visitor();

    source.unit?.visitChildren(_visitor);

    return _visitor.emptyBlocks
        .map((block) => createIssue(
              rule: this,
              location: nodeLocation(
                node: block,
                source: source,
                withCommentOrMetadata: true,
              ),
              message: _failure,
            ))
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
        !(node.endToken.precedingComments?.lexeme.contains('TODO') ?? false)) {
      _emptyBlocks.add(node);
    }
  }
}
