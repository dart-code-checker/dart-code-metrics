part of 'prefer_single_widget_per_file_rule.dart';

class _Visitor extends SimpleAstVisitor<void> {
  final bool _ignorePrivateWidgets;

  final _nodes = <ClassDeclaration>[];

  _Visitor({required bool ignorePrivateWidgets})
      : _ignorePrivateWidgets = ignorePrivateWidgets;

  Iterable<ClassDeclaration> get nodes =>
      _nodes.length > 1 ? _nodes.skip(1) : [];

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    super.visitClassDeclaration(node);

    final classType = node.extendsClause?.superclass.type;
    if (isWidgetOrSubclass(classType) &&
        (!_ignorePrivateWidgets ||
            !Identifier.isPrivateName(node.name.lexeme))) {
      _nodes.add(node);
    }
  }
}
