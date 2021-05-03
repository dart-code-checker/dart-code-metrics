part of 'avoid_returning_widgets.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final _declarations = <Declaration>[];

  final Iterable<String> _ignoredNames;

  Iterable<Declaration> get declarations => _declarations;

  _Visitor(this._ignoredNames);

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    super.visitMethodDeclaration(node);

    if (!node.isGetter && !node.isSetter && !_isIgnored(node.name.name)) {
      final type = node.returnType?.type;
      if (type != null && _hasWidgetType(type)) {
        _declarations.add(node);
      }
    }
  }

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    super.visitFunctionDeclaration(node);

    if (!node.isGetter && !node.isSetter && !_isIgnored(node.name.name)) {
      final type = node.returnType?.type;
      if (type != null && _hasWidgetType(type)) {
        _declarations.add(node);
      }
    }
  }

  bool _hasWidgetType(DartType type) =>
      _isWidget(type) ||
      _isSubclassOfWidget(type) ||
      _isIterable(type) ||
      _isList(type) ||
      _isFuture(type);

  bool _isIterable(DartType type) =>
      type.isDartCoreIterable &&
      type is InterfaceType &&
      (_isWidget(type.typeArguments.firstOrNull) ||
          _isSubclassOfWidget(type.typeArguments.firstOrNull));

  bool _isList(DartType type) =>
      type.isDartCoreList &&
      type is InterfaceType &&
      (_isWidget(type.typeArguments.firstOrNull) ||
          _isSubclassOfWidget(type.typeArguments.firstOrNull));

  bool _isFuture(DartType type) =>
      type.isDartAsyncFuture &&
      type is InterfaceType &&
      (_isWidget(type.typeArguments.firstOrNull) ||
          _isSubclassOfWidget(type.typeArguments.firstOrNull));

  bool _isWidget(DartType? type) =>
      type?.getDisplayString(withNullability: false) == 'Widget';

  bool _isSubclassOfWidget(DartType? type) =>
      type is InterfaceType &&
      type.allSupertypes.firstWhereOrNull(_isWidget) != null;

  bool _isIgnored(String name) =>
      name == 'build' || _ignoredNames.contains(name);
}
