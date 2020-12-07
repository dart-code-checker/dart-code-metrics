import 'package:analyzer/dart/ast/ast.dart';
import 'package:meta/meta.dart';

import 'function_type.dart';

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
