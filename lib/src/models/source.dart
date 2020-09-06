import 'package:analyzer/dart/ast/ast.dart';
import 'package:meta/meta.dart';

@immutable
class Source {
  final Uri url;
  final String content;
  final CompilationUnit compilationUnit;

  const Source(this.url, this.content, this.compilationUnit);
}
