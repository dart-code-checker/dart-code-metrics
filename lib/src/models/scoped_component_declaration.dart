import 'package:analyzer/dart/ast/ast.dart';
import 'package:meta/meta.dart';

@immutable
class ScopedComponentDeclaration {
  final CompilationUnitMember declaration;

  const ScopedComponentDeclaration(this.declaration);
}
