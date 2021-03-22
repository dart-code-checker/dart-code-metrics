import 'package:analyzer/dart/ast/ast.dart';
import 'package:meta/meta.dart';

import 'class_type.dart';

/// Represents a declaration of a class / mixin / extension.
@immutable
class ScopedClassDeclaration {
  /// The type of the declared class entity.
  final ClassType type;

  /// The node that represents in the AST structure for a Dart program.
  final CompilationUnitMember declaration;

  /// Returns the user defined name.
  String get name {
    if (declaration is ExtensionDeclaration) {
      return (declaration as ExtensionDeclaration).name.name;
    } else if (declaration is NamedCompilationUnitMember) {
      return (declaration as NamedCompilationUnitMember).name.name;
    }

    return '';
  }

  /// Initialize a newly created [ScopedClassDeclaration] with the given [type] and [declaration].
  const ScopedClassDeclaration(this.type, this.declaration);
}
