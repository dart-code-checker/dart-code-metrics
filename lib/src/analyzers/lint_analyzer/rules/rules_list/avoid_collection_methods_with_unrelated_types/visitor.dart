part of 'avoid_collection_methods_with_unrelated_types_rule.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final _expressions = <Expression>[];

  Iterable<Expression> get expressions => _expressions;

  // for `operator []` and `operator []=`
  @override
  void visitIndexExpression(IndexExpression node) {
    super.visitIndexExpression(node);

    final mapType = _getMapTypeElement(node.target?.staticType);
    _addIfNotSubType(node.index.staticType, mapType?.first, node);
  }

  // for things like `map.containsKey`
  @override
  void visitMethodInvocation(MethodInvocation node) {
    super.visitMethodInvocation(node);

    final argType = node.argumentList.arguments.singleOrNull?.staticType;

    switch (node.methodName.name) {
      case 'containsKey':
        final mapType = _getMapTypeElement(node.target?.staticType);
        _addIfNotSubType(argType, mapType?.first, node);
        break;
      case 'remove':
        final mapType = _getMapTypeElement(node.target?.staticType);
        _addIfNotSubType(argType, mapType?.first, node);

        final listType = _getListTypeElement(node.target?.staticType);
        _addIfNotSubType(argType, listType, node);
        break;
      case 'containsValue':
        final mapType = _getMapTypeElement(node.target?.staticType);
        _addIfNotSubType(argType, mapType?[1], node);
        break;
      case 'contains':
        final iterableType = _getIterableTypeElement(node.target?.staticType);
        _addIfNotSubType(argType, iterableType, node);
        break;
    }
  }

  void _addIfNotSubType(
    DartType? childType,
    ClassElement? parentElement,
    Expression node,
  ) {
    if (parentElement != null &&
        childType != null &&
        childType.asInstanceOf(parentElement) == null) {
      _expressions.add(node);
    }
  }

  List<ClassElement>? _getMapTypeElement(DartType? type) =>
      _getTypeArgElements(getSupertypeMap(type));

  ClassElement? _getIterableTypeElement(DartType? type) =>
      _getTypeArgElements(getSupertypeIterable(type))?.singleOrNull;

  ClassElement? _getListTypeElement(DartType? type) =>
      _getTypeArgElements(getSupertypeList(type))?.singleOrNull;

  List<ClassElement>? _getTypeArgElements(DartType? type) {
    if (type == null || type is! ParameterizedType) {
      return null;
    }

    final typeArgElements = type.typeArguments
        .map((arg) => arg.element)
        .whereType<ClassElement>()
        .toList();
    if (typeArgElements.length < type.typeArguments.length) {
      return null;
    }

    return typeArgElements;
  }
}
