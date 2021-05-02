import 'package:analyzer/dart/ast/ast.dart';

import '../models/scoped_function_declaration.dart';

int getArgumentsCount(ScopedFunctionDeclaration dec) {
  final declaration = dec.declaration;

  int? argumentsCount;
  if (declaration is FunctionDeclaration) {
    argumentsCount =
        declaration.functionExpression.parameters?.parameters.length;
  } else if (declaration is MethodDeclaration) {
    argumentsCount = declaration.parameters?.parameters.length;
  }

  return argumentsCount ?? 0;
}
