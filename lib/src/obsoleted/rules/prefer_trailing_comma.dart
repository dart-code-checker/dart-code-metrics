import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/syntactic_entity.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/source/line_info.dart';

import '../../models/issue.dart';
import '../../models/replacement.dart';
import '../../models/severity.dart';
import '../../utils/node_utils.dart';
import '../../utils/rule_utils.dart';
import '../models/internal_resolved_unit_result.dart';
import 'obsolete_rule.dart';

class PreferTrailingComma extends ObsoleteRule {
  static const String ruleId = 'prefer-trailing-comma';

  static const _warningMessage = 'Prefer trailing comma';
  static const _correctionMessage = 'Add trailing comma';

  final int? _itemsBreakpoint;

  PreferTrailingComma({Map<String, Object> config = const {}})
      : _itemsBreakpoint = _parseItemsBreakpoint(config),
        super(
          id: ruleId,
          severity: readSeverity(config, Severity.warning),
          excludes: readExcludes(config),
        );

  @override
  Iterable<Issue> check(InternalResolvedUnitResult source) {
    final visitor = _Visitor(source.lineInfo, _itemsBreakpoint);

    source.unit.visitChildren(visitor);

    return visitor.nodes
        .map(
          (node) => createIssue(
            rule: this,
            location: nodeLocation(
              node: node,
              source: source,
              withCommentOrMetadata: true,
            ),
            message: _warningMessage,
            replacement: Replacement(
              comment: _correctionMessage,
              replacement:
                  '${source.content.substring(node.offset, node.end)},',
            ),
          ),
        )
        .toList(growable: false);
  }

  static int? _parseItemsBreakpoint(Map<String, Object> config) {
    final breakpoint = config.containsKey('break-on')
        ? config['break-on']
        : config['break_on'];

    return breakpoint != null ? int.tryParse(breakpoint.toString()) : null;
  }
}

class _Visitor extends RecursiveAstVisitor<void> {
  final LineInfo _lineInfo;
  final int? _breakpoint;

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

    if (last.endToken.next?.type != TokenType.COMMA &&
        (!_isLastItemMultiLine(last, leftBracket, rightBracket) &&
                _getLineNumber(leftBracket) != _getLineNumber(rightBracket) ||
            _breakpoint != null && nodes.length >= _breakpoint!)) {
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
