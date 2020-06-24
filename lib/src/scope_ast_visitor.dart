import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

import 'models/scoped_declaration.dart';

class ScopeAstVisitor extends RecursiveAstVisitor<Object> {
  final _functions = <ScopedDeclaration>[];

  CompilationUnitMember _enclosingDeclaration;

  Iterable<ScopedDeclaration> get functions => _functions;

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    _enclosingDeclaration = node;
    super.visitClassDeclaration(node);
    _enclosingDeclaration = null;
  }

  @override
  void visitConstructorDeclaration(ConstructorDeclaration node) {
    if (node.body is! EmptyFunctionBody) {
      _registerDeclaration(node);
    }
    super.visitConstructorDeclaration(node);
  }

  @override
  void visitExtensionDeclaration(ExtensionDeclaration node) {
    _enclosingDeclaration = node;
    super.visitExtensionDeclaration(node);
    _enclosingDeclaration = null;
  }

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    _registerDeclaration(node);
    super.visitFunctionDeclaration(node);
  }

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    if (node.body is! EmptyFunctionBody) {
      _registerDeclaration(node);
    }
    super.visitMethodDeclaration(node);
  }

  @override
  void visitMixinDeclaration(MixinDeclaration node) {
    _enclosingDeclaration = node;
    super.visitMixinDeclaration(node);
    _enclosingDeclaration = null;
  }

  void _registerDeclaration(Declaration node) {
    _functions.add(ScopedDeclaration(node, _enclosingDeclaration));
  }
}
