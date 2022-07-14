import 'package:analyzer/dart/ast/ast.dart';

import '../models/scoped_function_declaration.dart';

/// Returns functions belonging to the passed [classNode]
Iterable<ScopedFunctionDeclaration> classMethods(
  AstNode classNode,
  Iterable<ScopedFunctionDeclaration> functionDeclarations,
) =>
    functionDeclarations
        .where((func) => func.enclosingDeclaration?.declaration == classNode)
        .toList(growable: false);
