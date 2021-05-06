import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:code_checker/checker.dart';
import 'package:code_checker/rules.dart';

// Inspired by PVS-Studio (https://www.viva64.com/en/w/v6004/)

class NoEqualThenElse extends Rule {
  static const String ruleId = 'no-equal-then-else';
  static const _documentationUrl = 'https://git.io/J31OQ';

  static const _warningMessage = 'Then and else branches are equal';

  NoEqualThenElse({Map<String, Object> config = const {}})
      : super(
          id: ruleId,
          documentation: Uri.parse(_documentationUrl),
          severity: readSeverity(config, Severity.warning),
        );

  @override
  Iterable<Issue> check(ProcessedFile file) {
    final _visitor = _Visitor();

    file.parsedContent.visitChildren(_visitor);

    return _visitor.nodes
        .map(
          (node) => createIssue(
            this,
            nodeLocation(node: node, source: file, withCommentOrMetadata: true),
            _warningMessage,
            null,
          ),
        )
        .toList(growable: false);
  }
}

class _Visitor extends RecursiveAstVisitor<void> {
  final _nodes = <AstNode>[];

  Iterable<AstNode> get nodes => _nodes;

  @override
  void visitIfStatement(IfStatement node) {
    super.visitIfStatement(node);

    if (node.elseStatement != null &&
        node.elseStatement is! IfStatement &&
        node.thenStatement.toString() == node.elseStatement.toString()) {
      _nodes.add(node);
    }
  }

  @override
  void visitConditionalExpression(ConditionalExpression node) {
    super.visitConditionalExpression(node);

    if (node.thenExpression?.toString() == node.elseExpression?.toString()) {
      _nodes.add(node);
    }
  }
}
