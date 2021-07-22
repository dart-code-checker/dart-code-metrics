part of 'prefer_single_widget_per_file.dart';

class _Visitor extends SimpleAstVisitor<void> {
  final _nodes = <ClassDeclaration>[];

  Iterable<ClassDeclaration> get nodes =>
      _nodes.length > 1 ? _nodes.skip(1) : [];

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    super.visitClassDeclaration(node);

    final classType = node.extendsClause?.superclass.type;
    if (isWidgetOrSubclass(classType)) {
      _nodes.add(node);
    }
  }
}
