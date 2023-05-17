part of 'avoid_collection_methods_with_unrelated_types_rule.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final _expressions = <Expression>[];

  final bool _isStrictMode;

  Iterable<Expression> get expressions => _expressions;

  // ignore: avoid_positional_boolean_parameters
  _Visitor(this._isStrictMode);

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

    final staticType = node.target?.staticType;

    final mapType = _getMapTypeElement(staticType);
    final listType = _getListTypeElement(staticType);
    final setType = _getSetTypeElement(staticType);
    final iterableType = _getIterableTypeElement(staticType);
    final argType = node.argumentList.arguments.singleOrNull?.staticType;

    switch (node.methodName.name) {
      case 'containsKey':
        _addIfNotSubType(argType, mapType?.first, node);
        break;
      case 'remove':
        _addIfNotSubType(argType, mapType?.first, node);
        _addIfNotSubType(argType, listType, node);
        _addIfNotSubType(argType, setType, node);
        break;
      case 'lookup':
        _addIfNotSubType(argType, setType, node);
        break;
      case 'containsValue':
        _addIfNotSubType(argType, mapType?[1], node);
        break;
      case 'contains':
        _addIfNotSubType(argType, iterableType, node);
        break;
      case 'containsAll':
      case 'removeAll':
      case 'retainAll':
        final argAsIterableParamType = _getIterableTypeElement(argType);
        _addIfNotSubType(argAsIterableParamType?.type, setType, node);
        break;
      case 'difference':
      case 'intersection':
        final argAsSetParamType = _getSetTypeElement(argType);
        _addIfNotSubType(argAsSetParamType?.type, setType, node);
        break;
    }
  }

  void _addIfNotSubType(
    DartType? childType,
    _TypedClassElement? parentElement,
    Expression node,
  ) {
    if (parentElement != null &&
        childType != null &&
        (_isNotInstance(childType, parentElement) &&
            _isNotDynamic(childType)) &&
        !(isNullableType(parentElement.type) && childType.isDartCoreNull)) {
      _expressions.add(node);
    }
  }

  bool _isNotInstance(DartType type, _TypedClassElement parentElement) =>
      type.asInstanceOf(parentElement.element) == null;

  bool _isNotDynamic(DartType type) =>
      // ignore: deprecated_member_use
      _isStrictMode || !(type.isDynamic || type.isDartCoreObject);

  List<_TypedClassElement>? _getMapTypeElement(DartType? type) =>
      _getTypeArgElements(getSupertypeMap(type));

  _TypedClassElement? _getIterableTypeElement(DartType? type) =>
      _getTypeArgElements(getSupertypeIterable(type))?.singleOrNull;

  _TypedClassElement? _getListTypeElement(DartType? type) =>
      _getTypeArgElements(getSupertypeList(type))?.singleOrNull;

  _TypedClassElement? _getSetTypeElement(DartType? type) =>
      _getTypeArgElements(getSupertypeSet(type))?.singleOrNull;

  List<_TypedClassElement>? _getTypeArgElements(DartType? type) {
    if (type == null || type is! ParameterizedType) {
      return null;
    }

    final typeArgElements = type.typeArguments
        .map((typeArg) {
          // ignore: deprecated_member_use
          final element = typeArg.element2;

          return element is ClassElement
              ? _TypedClassElement(typeArg, element)
              : null;
        })
        .whereNotNull()
        .toList();
    if (typeArgElements.length < type.typeArguments.length) {
      return null;
    }

    return typeArgElements;
  }
}

class _TypedClassElement {
  final DartType type;
  final ClassElement element;

  _TypedClassElement(this.type, this.element);
}
