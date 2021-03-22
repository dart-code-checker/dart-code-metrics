import 'package:analyzer/dart/ast/ast.dart';
import 'package:meta/meta.dart';

import 'function_type.dart';
import 'scoped_class_declaration.dart';

/// Represents a declaration of function / method.
@immutable
class ScopedFunctionDeclaration {
  /// The type of the declared function entity.
  final FunctionType type;

  /// The node that represents in the AST structure for a Dart program.
  final Declaration declaration;

  /// The class declaration of the class to which this function belongs.
  final ScopedClassDeclaration enclosingDeclaration;

  /// Returns the user defined name.
  String get name {
    if (declaration is FunctionDeclaration) {
      return (declaration as FunctionDeclaration).name?.name;
    } else if (declaration is ConstructorDeclaration) {
      return (declaration as ConstructorDeclaration).name?.name ??
          (declaration.parent as NamedCompilationUnitMember).name?.name;
    } else if (declaration is MethodDeclaration) {
      return (declaration as MethodDeclaration).name?.name;
    }

    return null;
  }

  /// Returns the full user defined name.
  ///
  /// using the pattern `className.methodName`.
  String get fullName {
    final className = enclosingDeclaration?.name;
    final functionName = name;

    return functionName == null
        ? null
        : (className == null ? name : '$className.$functionName');
  }

  /// Initialize a newly created [ScopedFunctionDeclaration] with the given [type], [declaration] and [enclosingDeclaration].
  const ScopedFunctionDeclaration(
    this.type,
    this.declaration,
    this.enclosingDeclaration,
  );
}
