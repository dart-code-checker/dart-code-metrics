import 'package:analyzer/dart/ast/ast.dart';
import 'package:meta/meta.dart';

@immutable
class ScopedFunctionDeclaration {
  final Declaration declaration;
  final CompilationUnitMember enclosingDeclaration;

  const ScopedFunctionDeclaration(this.declaration, this.enclosingDeclaration);
}
