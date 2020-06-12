import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/syntactic_entity.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/source/line_info.dart';
import 'package:dart_code_metrics/src/models/code_issue.dart';
import 'package:dart_code_metrics/src/models/code_issue_severity.dart';
import 'package:dart_code_metrics/src/rules/rule_utils.dart';

import 'base_rule.dart';

class PreferTrailingCommasForCollectionRule extends BaseRule {
  static const _failure = 'A trailing comma should end this line';

  const PreferTrailingCommasForCollectionRule()
      : super(
          id: 'prefer-trailing-commas-for-collection',
          severity: CodeIssueSeverity.style,
        );

  @override
  Iterable<CodeIssue> check(
      CompilationUnit unit, Uri sourceUrl, String sourceContent) {
    final visitor = _Visitor(
      unit.lineInfo,
    );

    unit.visitChildren(visitor);

    return visitor.nodes
        .map((node) => createIssue(
            this,
            _failure,
            '${node.toSource()},',
            'Add trailing comma',
            sourceUrl,
            sourceContent,
            unit.lineInfo,
            node))
        .toList();
  }
}

class _Visitor extends GeneralizingAstVisitor<void> {
  final _nodes = <AstNode>[];
  final LineInfo _lineInfo;

  _Visitor(this._lineInfo);

  Iterable<AstNode> get nodes => _nodes;

  @override
  void visitListLiteral(ListLiteral node) {
    _visitNodeList(node.elements, node.leftBracket, node.rightBracket);
    super.visitListLiteral(node);
  }

  @override
  void visitSetOrMapLiteral(SetOrMapLiteral node) {
    _visitNodeList(node.elements, node.leftBracket, node.rightBracket);
    super.visitSetOrMapLiteral(node);
  }

  void _visitNodeList(
    List<AstNode> list,
    Token leftBracket,
    Token rightBracket,
  ) {
    if (list.isEmpty ||
        (_getLineNumber(leftBracket) == _getLineNumber(rightBracket))) {
      return;
    }

    if (list.last.endToken?.next?.type != TokenType.COMMA &&
        (_getLineNumber(leftBracket) != _getLineNumber(list.first) ||
            _getLineNumber(rightBracket) != _getLineNumber(list.last))) {
      _nodes.add(list.last);
    }
  }

  int _getLineNumber(SyntacticEntity entity) =>
      _lineInfo.getLocation(entity.offset).lineNumber;
}
