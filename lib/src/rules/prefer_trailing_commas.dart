import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/source/line_info.dart';
import 'package:dart_code_metrics/src/models/code_issue.dart';
import 'package:dart_code_metrics/src/models/code_issue_severity.dart';
import 'package:dart_code_metrics/src/rules/rule_utils.dart';

import 'base_rule.dart';

class PreferTrailingCommasRule extends BaseRule {
  static const _failure = 'A trailing comma should end this line';

  const PreferTrailingCommasRule()
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
        .map((node) => createIssue(this, _failure, null, null, sourceUrl, sourceContent, unit.lineInfo, node))
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
    _visitNodeList(node.elements);
    super.visitListLiteral(node);
  }

  @override
  void visitSetOrMapLiteral(SetOrMapLiteral node) {
    _visitNodeList(node.elements);
    super.visitSetOrMapLiteral(node);
  }

  void _visitNodeList(List<AstNode> list) {
    if (list.length < 2) {
      return;
    }

    if (_getLineNumber(list.first) == _getLineNumber(list.last)) {
      return;
    }

    final lastNode = list[list.length - 1];
    final preLastNode = list[list.length - 2];

    if (list.last.endToken?.next?.type != TokenType.COMMA &&
        _getLineNumber(lastNode) != _getLineNumber(preLastNode)) {
      _nodes.add(list.last);
    }
  }

  int _getLineNumber(AstNode node) =>
      _lineInfo.getLocation(node.offset).lineNumber;
}
