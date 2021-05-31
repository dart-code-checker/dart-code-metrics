import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

import '../models/class_type.dart';
import '../models/function_type.dart';
import '../models/scoped_class_declaration.dart';
import '../models/scoped_function_declaration.dart';

/// A visitor to collect declarations of classes and functions.
class ScopeVisitor extends RecursiveAstVisitor<void> {
  final _classes = <ScopedClassDeclaration>[];
  final _functions = <ScopedFunctionDeclaration>[];

  ScopedClassDeclaration? _enclosingDeclaration;

  /// Returns the declarations of the found classes.
  Iterable<ScopedClassDeclaration> get classes => _classes;

  /// Returns the declarations of the found functions.
  Iterable<ScopedFunctionDeclaration> get functions => _functions;

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    _registerClassDeclaration(ClassType.generic, node, () {
      super.visitClassDeclaration(node);
    });
  }

  @override
  void visitConstructorDeclaration(ConstructorDeclaration node) {
    _registerFunctionDeclaration(FunctionType.constructor, node);

    super.visitConstructorDeclaration(node);
  }

  @override
  void visitExtensionDeclaration(ExtensionDeclaration node) {
    _registerClassDeclaration(ClassType.extension, node, () {
      super.visitExtensionDeclaration(node);
    });
  }

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    _registerFunctionDeclaration(FunctionType.function, node);

    super.visitFunctionDeclaration(node);
  }

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    var type = FunctionType.method;
    if (node.isGetter) {
      type = FunctionType.getter;
    } else if (node.isSetter) {
      type = FunctionType.setter;
    }

    _registerFunctionDeclaration(type, node);

    super.visitMethodDeclaration(node);
  }

  @override
  void visitMixinDeclaration(MixinDeclaration node) {
    _registerClassDeclaration(ClassType.mixin, node, () {
      super.visitMixinDeclaration(node);
    });
  }

  void _registerClassDeclaration(
    ClassType type,
    CompilationUnitMember node,
    void Function() visitCallback,
  ) {
    _enclosingDeclaration = ScopedClassDeclaration(type, node);
    _classes.add(_enclosingDeclaration!);

    visitCallback();

    _enclosingDeclaration = null;
  }

  void _registerFunctionDeclaration(FunctionType type, Declaration node) {
    _functions
        .add(ScopedFunctionDeclaration(type, node, _enclosingDeclaration));
  }
}
