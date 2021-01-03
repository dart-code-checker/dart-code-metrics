import 'package:analyzer/dart/ast/ast.dart';

String getDeclarationHumanReadableName(Declaration declaration) {
  if (declaration is FunctionDeclaration) {
    return declaration.name?.name;
  } else if (declaration is ConstructorDeclaration) {
    return declaration.name?.name ??
        (declaration.parent as NamedCompilationUnitMember).name?.name;
  } else if (declaration is MethodDeclaration) {
    return declaration.name?.name;
  }

  return null;
}
