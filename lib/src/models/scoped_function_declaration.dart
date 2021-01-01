import 'package:analyzer/dart/ast/ast.dart';
import 'package:code_checker/checker.dart';
import 'package:meta/meta.dart';

@immutable
class ScopedFunctionDeclaration {
  final FunctionType type;
  final Declaration declaration;
  final CompilationUnitMember enclosingDeclaration;

  const ScopedFunctionDeclaration(
    this.type,
    this.declaration,
    this.enclosingDeclaration,
  );
}
