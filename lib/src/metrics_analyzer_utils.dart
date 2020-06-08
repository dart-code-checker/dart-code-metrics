import 'package:analyzer/dart/ast/ast.dart';

import 'models/scoped_declaration.dart';

int getArgumentsCount(ScopedDeclaration dec) {
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

String getHumanReadableName(ScopedDeclaration dec) {
  final declaration = dec.declaration;

  if (declaration is FunctionDeclaration) {
    return declaration.name.toString();
  } else if (declaration is ConstructorDeclaration) {
    return '${dec.declarationIdentifier}.${declaration.name}';
  } else if (declaration is MethodDeclaration) {
    return '${dec.declarationIdentifier}.${declaration.name}';
  }

  return null;
}
