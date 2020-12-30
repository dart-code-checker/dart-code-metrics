import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/syntactic_entity.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/source/line_info.dart';
import 'package:code_checker/rules.dart';
import 'package:dart_code_metrics/src/rules/rule_utils.dart';

class PreferTrailingComma extends Rule {
  static const String ruleId = 'prefer-trailing-comma';
  static const _documentationUrl = 'https://git.io/Jkemi';

  static const _warningMessage = 'Prefer trailing comma';
  static const _correctionMessage = 'Add trailing comma';

  final int _itemsBreakpoint;

  PreferTrailingComma({Map<String, Object> config = const {}})
      : _itemsBreakpoint = _parseItemsBreakpoint(config),
        super(
          id: ruleId,
          documentation: Uri.parse(_documentationUrl),
          severity: Severity.fromJson(config['severity'] as String) ??
              Severity.warning,
        );

  @override
  Iterable<Issue> check(ProcessedFile file) {
    final visitor = _Visitor(file.parsedContent.lineInfo, _itemsBreakpoint);

    file.parsedContent.visitChildren(visitor);

    return visitor.nodes
        .map(
          (node) => createIssue(
            this,
            _warningMessage,
            '${file.content.substring(node.offset, node.end)},',
            _correctionMessage,
            file.url,
            file.content,
            file.parsedContent,
            node,
          ),
        )
        .toList(growable: false);
  }

  static int _parseItemsBreakpoint(Map<String, Object> config) {
    final breakpoint = config['break_on'];

    return breakpoint != null ? int.tryParse(breakpoint.toString()) : null;
  }
}

class _Visitor extends RecursiveAstVisitor<void> {
  final LineInfo _lineInfo;
  final int _breakpoint;

  final _nodes = <AstNode>[];

  Iterable<AstNode> get nodes => _nodes;

  _Visitor(this._lineInfo, this._breakpoint);

  @override
  void visitArgumentList(ArgumentList node) {
    super.visitArgumentList(node);

    _visitNodeList(node.arguments, node.leftParenthesis, node.rightParenthesis);
  }

  @override
  void visitFormalParameterList(FormalParameterList node) {
    super.visitFormalParameterList(node);

    _visitNodeList(
      node.parameters,
      node.leftParenthesis,
      node.rightParenthesis,
    );
  }

  @override
  void visitEnumDeclaration(EnumDeclaration node) {
    super.visitEnumDeclaration(node);

    _visitNodeList(node.constants, node.leftBracket, node.rightBracket);
  }

  @override
  void visitListLiteral(ListLiteral node) {
    super.visitListLiteral(node);

    _visitNodeList(node.elements, node.leftBracket, node.rightBracket);
  }

  @override
  void visitSetOrMapLiteral(SetOrMapLiteral node) {
    super.visitSetOrMapLiteral(node);

    _visitNodeList(node.elements, node.leftBracket, node.rightBracket);
  }

  void _visitNodeList(
    Iterable<AstNode> nodes,
    Token leftBracket,
    Token rightBracket,
  ) {
    if (nodes.isEmpty) {
      return;
    }

    final last = nodes.last;

    if (last.endToken?.next?.type != TokenType.COMMA &&
        (!_isLastItemMultiLine(last, leftBracket, rightBracket) &&
                _getLineNumber(leftBracket) != _getLineNumber(rightBracket) ||
            _breakpoint != null && nodes.length >= _breakpoint)) {
      _nodes.add(last);
    }
  }

  bool _isLastItemMultiLine(
    AstNode node,
    Token leftBracket,
    Token rightBracket,
  ) =>
      _getLineNumber(leftBracket) ==
          _lineInfo.getLocation(node.offset).lineNumber &&
      _getLineNumber(rightBracket) ==
          _lineInfo.getLocation(node.end).lineNumber;

  int _getLineNumber(SyntacticEntity entity) =>
      _lineInfo.getLocation(entity.offset).lineNumber;
}
