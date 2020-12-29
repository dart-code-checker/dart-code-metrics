import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:code_checker/analysis.dart';

import 'base_rule.dart';
import 'rule_utils.dart';

// Inspired by TSLint (https://palantir.github.io/tslint/rules/no-empty/)

class NoEmptyBlockRule extends BaseRule {
  static const String ruleId = 'no-empty-block';
  static const _documentationUrl = 'https://git.io/JfDi3';

  static const _failure =
      'Block is empty. Empty blocks are often indicators of missing code.';

  NoEmptyBlockRule({Map<String, Object> config = const {}})
      : super(
          id: ruleId,
          documentation: Uri.parse(_documentationUrl),
          severity:
              Severity.fromJson(config['severity'] as String) ?? Severity.style,
        );

  @override
  Iterable<Issue> check(ProcessedFile source) {
    final _visitor = _Visitor();

    source.parsedContent.visitChildren(_visitor);

    return _visitor.emptyBlocks
        .map((block) => createIssue(
              this,
              _failure,
              null,
              null,
              source.url,
              source.content,
              source.parsedContent.lineInfo,
              block,
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
        !(node.endToken.precedingComments?.lexeme?.contains('TODO') ?? false)) {
      _emptyBlocks.add(node);
    }
  }
}
