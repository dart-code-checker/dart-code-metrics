import 'package:analyzer/dart/ast/ast.dart';
import 'package:code_checker/checker.dart';

import 'declaration_utils.dart';

int getArgumentsCount(ScopedFunctionDeclaration dec) {
  final declaration = dec.declaration;

  int argumentsCount;
  if (declaration is FunctionDeclaration) {
    argumentsCount =
        declaration.functionExpression?.parameters?.parameters?.length;
  } else if (declaration is MethodDeclaration) {
    argumentsCount = declaration?.parameters?.parameters?.length;
  }

  return argumentsCount ?? 0;
}

String getFunctionHumanReadableName(ScopedFunctionDeclaration dec) {
  if (dec == null) {
    return null;
  }

  final functionName = getDeclarationHumanReadableName(dec.declaration);
  final enclosingDeclaration = dec.enclosingDeclaration?.declaration;

  final name = [
    if (enclosingDeclaration != null &&
        enclosingDeclaration is NamedCompilationUnitMember)
      enclosingDeclaration.name.name,
    if (enclosingDeclaration != null &&
        enclosingDeclaration is ExtensionDeclaration)
      enclosingDeclaration.name.name,
    if (functionName != null) functionName,
  ];

  return name.join('.');
}
