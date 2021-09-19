part of 'prefer_const_border_radius.dart';

class _Visitor extends ScopeVisitor {
  final _constructors = <ConstructorDeclaration>[];

  Iterable<ConstructorDeclaration> get constructorNodes => _constructors;


  @override
  void visitConstructorDeclaration(ConstructorDeclaration node) {
    super.visitConstructorDeclaration(node);

    _constructors.add(node);
  }
}
