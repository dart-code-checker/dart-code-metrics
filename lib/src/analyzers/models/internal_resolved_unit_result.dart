import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/source/line_info.dart';

class InternalResolvedUnitResult {
  final Uri sourceUri;
  final String content;
  final CompilationUnit unit;
  final LineInfo lineInfo;

  String get path => sourceUri.toString();

  InternalResolvedUnitResult(
    this.sourceUri,
    this.content,
    this.unit,
    this.lineInfo,
  );
}
