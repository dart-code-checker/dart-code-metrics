import 'package:analyzer/dart/ast/ast.dart';

import 'models/scoped_component_declaration.dart';
import 'models/scoped_function_declaration.dart';

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

String getComponentHumanReadableName(ScopedComponentDeclaration dec) {
  if (dec == null) {
    return null;
  }

  final declaration = dec.declaration;

  if (declaration is ExtensionDeclaration) {
    return declaration.name.name;
  } else if (declaration is NamedCompilationUnitMember) {
    return declaration.name.name;
  }

  return '';
}

String getFunctionHumanReadableName(ScopedFunctionDeclaration dec) {
  if (dec == null) {
    return null;
  }

  final declaration = dec.declaration;
  final enclosingDeclaration = dec.enclosingDeclaration;

  final name = [
    if (enclosingDeclaration != null &&
        enclosingDeclaration is NamedCompilationUnitMember)
      enclosingDeclaration.name.name,
    if (enclosingDeclaration != null &&
        enclosingDeclaration is ExtensionDeclaration)
      enclosingDeclaration.name.name,
    if (declaration != null && declaration is FunctionDeclaration)
      declaration.name.name,
    if (declaration != null && declaration is ConstructorDeclaration)
      declaration.name?.name ??
          (declaration.parent as NamedCompilationUnitMember).name.name,
    if (declaration != null && declaration is MethodDeclaration)
      declaration.name.name,
  ];

  return name.join('.');
}
