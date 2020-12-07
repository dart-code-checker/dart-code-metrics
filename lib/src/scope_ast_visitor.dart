import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

import 'models/function_type.dart';
import 'models/scoped_component_declaration.dart';
import 'models/scoped_function_declaration.dart';

class ScopeAstVisitor extends RecursiveAstVisitor<void> {
  final _components = <ScopedComponentDeclaration>[];
  final _functions = <ScopedFunctionDeclaration>[];

  CompilationUnitMember _enclosingDeclaration;

  Iterable<ScopedComponentDeclaration> get components => _components;
  Iterable<ScopedFunctionDeclaration> get functions => _functions;

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    _components.add(ScopedComponentDeclaration(node));
    _enclosingDeclaration = node;
    super.visitClassDeclaration(node);
    _enclosingDeclaration = null;
  }

  @override
  void visitConstructorDeclaration(ConstructorDeclaration node) {
    if (node.body is! EmptyFunctionBody) {
      _registerDeclaration(FunctionType.classConstructor, node);
    }
    super.visitConstructorDeclaration(node);
  }

  @override
  void visitExtensionDeclaration(ExtensionDeclaration node) {
    _components.add(ScopedComponentDeclaration(node));
    _enclosingDeclaration = node;
    super.visitExtensionDeclaration(node);
    _enclosingDeclaration = null;
  }

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    _registerDeclaration(FunctionType.staticFunction, node);
    super.visitFunctionDeclaration(node);
  }

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    if (node.body is! EmptyFunctionBody) {
      _registerDeclaration(FunctionType.classMethod, node);
    }
    super.visitMethodDeclaration(node);
  }

  @override
  void visitMixinDeclaration(MixinDeclaration node) {
    _components.add(ScopedComponentDeclaration(node));
    _enclosingDeclaration = node;
    super.visitMixinDeclaration(node);
    _enclosingDeclaration = null;
  }

  void _registerDeclaration(FunctionType type, Declaration node) {
    _functions
        .add(ScopedFunctionDeclaration(type, node, _enclosingDeclaration));
  }
}
