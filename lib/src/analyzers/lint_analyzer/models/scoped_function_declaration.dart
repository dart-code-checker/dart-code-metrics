import 'package:analyzer/dart/ast/ast.dart';

import 'function_type.dart';
import 'scoped_class_declaration.dart';

/// Represents a declaration of function / method.
class ScopedFunctionDeclaration {
  /// The type of the declared function entity.
  final FunctionType type;

  /// The node that represents a dart code snippet in the AST structure.
  final Declaration declaration;

  /// The class declaration of the class to which this function belongs.
  final ScopedClassDeclaration? enclosingDeclaration;

  /// Returns the user defined name.
  String get name {
    final node = declaration;
    String? name;

    if (node is FunctionDeclaration) {
      name = node.name.lexeme;
    } else if (node is ConstructorDeclaration) {
      name = node.name?.lexeme ??
          (node.parent as NamedCompilationUnitMember).name.lexeme;
    } else if (node is MethodDeclaration) {
      name = node.name.lexeme;
    }

    return name ?? '';
  }

  /// Returns the full user defined name.
  ///
  /// using the pattern `className.methodName`.
  String get fullName {
    final className = enclosingDeclaration?.name;
    final functionName = name;

    return className == null || className.isEmpty || functionName.isEmpty
        ? functionName
        : '$className.$functionName';
  }

  /// Initialize a newly created [ScopedFunctionDeclaration] with the given [type], [declaration] and [enclosingDeclaration].
  const ScopedFunctionDeclaration(
    this.type,
    this.declaration,
    this.enclosingDeclaration,
  );
}
