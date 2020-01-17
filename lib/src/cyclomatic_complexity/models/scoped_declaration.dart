import 'package:analyzer/dart/ast/ast.dart';
import 'package:meta/meta.dart';

@immutable
class ScopedDeclaration {
  final Declaration declaration;
  final NamedCompilationUnitMember enclosingClass;

  const ScopedDeclaration(this.declaration, this.enclosingClass);
}
