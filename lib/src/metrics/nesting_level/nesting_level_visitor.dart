import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/source/line_info.dart';

class NestingLevelVisitor extends RecursiveAstVisitor<void> {
  final Declaration _function;
  final LineInfo _lineInfo;
  final _nestingLines = <Iterable<int>>[];

  Iterable<Iterable<int>> get nestingLines => _nestingLines;

  NestingLevelVisitor(this._function, this._lineInfo);

  @override
  void visitBlock(Block node) {
    final lines = <int>[];

    AstNode astNode = node;
    do {
      if (astNode is Block) {
        if (astNode?.parent is! BlockFunctionBody ||
            astNode?.parent?.parent is FunctionExpression) {
          lines.add(_lineInfo.getLocation(astNode.offset).lineNumber);
        }
      }

      astNode = astNode.parent;
    } while (astNode.parent != _function);

    if (lines.isNotEmpty) {
      _nestingLines.add(lines);
    }

    super.visitBlock(node);
  }
}
