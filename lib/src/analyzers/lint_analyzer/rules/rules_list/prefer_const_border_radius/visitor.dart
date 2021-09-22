part of 'prefer_const_border_radius.dart';

class _Visitor extends RecursiveAstVisitor<dynamic> {
  final _constructors = <TypeName>[];

  Iterable<TypeName> get constructorNodes => _constructors;

  @override
  void visitTypeName(TypeName node) {
    super.visitTypeName(node);

    _constructors.add(node);
  }
}
