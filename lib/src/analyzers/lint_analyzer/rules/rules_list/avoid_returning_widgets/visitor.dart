part of 'avoid_returning_widgets.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final _declarations = <Declaration>[];

  final Iterable<String> _ignoredNames;
  final Iterable<String> _ignoredAnnotations;

  Iterable<Declaration> get declarations => _declarations;

  _Visitor(this._ignoredNames, this._ignoredAnnotations);

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    super.visitMethodDeclaration(node);

    _visitDeclaration(
      node,
      node.name,
      node.returnType,
      isSetter: node.isSetter,
    );
  }

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    super.visitFunctionDeclaration(node);

    _visitDeclaration(
      node,
      node.name,
      node.returnType,
      isSetter: node.isSetter,
    );
  }

  void _visitDeclaration(
    Declaration node,
    SimpleIdentifier name,
    TypeAnnotation? returnType, {
    required bool isSetter,
  }) {
    final hasIgnoredAnnotation = node.metadata.any(
      (node) =>
          _ignoredAnnotations.contains(node.name.name) &&
          node.atSign.type == TokenType.AT,
    );

    if (!hasIgnoredAnnotation && !isSetter && !_isIgnored(name.name)) {
      final type = returnType?.type;
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
      type is InterfaceType && type.allSupertypes.any(_isWidget);

  bool _isIgnored(String name) =>
      name == 'build' || _ignoredNames.contains(name);
}
