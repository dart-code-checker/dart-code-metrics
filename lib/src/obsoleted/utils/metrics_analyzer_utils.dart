// ignore_for_file: public_member_api_docs
import 'package:analyzer/dart/ast/ast.dart';
import 'package:code_checker/checker.dart';

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
