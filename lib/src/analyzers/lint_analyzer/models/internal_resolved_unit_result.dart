import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/source/line_info.dart';

/// Represents a resolved unit from an AST analysis.
class InternalResolvedUnitResult {
  final String path;
  final String content;
  final CompilationUnit unit;
  final LineInfo lineInfo;

  const InternalResolvedUnitResult(
    this.path,
    this.content,
    this.unit,
    this.lineInfo,
  );
}
