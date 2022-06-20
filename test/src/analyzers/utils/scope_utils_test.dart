import 'package:analyzer/dart/ast/ast.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/metrics/scope_utils.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/class_type.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/function_type.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/scoped_class_declaration.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/scoped_function_declaration.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class CompilationUnitMemberMock extends Mock implements CompilationUnitMember {}

class DeclarationMock extends Mock implements Declaration {}

void main() {
  test('classFunctions returns functions only enclosed by passed class', () {
    final firstClass =
        ScopedClassDeclaration(ClassType.generic, CompilationUnitMemberMock());
    final secondClass =
        ScopedClassDeclaration(ClassType.mixin, CompilationUnitMemberMock());
    final thirdClass = ScopedClassDeclaration(
      ClassType.extension,
      CompilationUnitMemberMock(),
    );

    final functions = [
      ScopedFunctionDeclaration(
        FunctionType.function,
        DeclarationMock(),
        null,
      ),
      ScopedFunctionDeclaration(
        FunctionType.constructor,
        DeclarationMock(),
        firstClass,
      ),
      ScopedFunctionDeclaration(
        FunctionType.method,
        DeclarationMock(),
        firstClass,
      ),
      ScopedFunctionDeclaration(
        FunctionType.constructor,
        DeclarationMock(),
        secondClass,
      ),
      ScopedFunctionDeclaration(
        FunctionType.method,
        DeclarationMock(),
        secondClass,
      ),
    ];

    expect(classMethods(firstClass.declaration, functions), hasLength(2));
    expect(classMethods(secondClass.declaration, functions), hasLength(2));
    expect(classMethods(thirdClass.declaration, functions), isEmpty);
  });
}
