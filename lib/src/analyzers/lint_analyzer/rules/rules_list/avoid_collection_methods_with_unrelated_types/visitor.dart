part of 'avoid_collection_methods_with_unrelated_types_rule.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final _expressions = <Expression>[];

  Iterable<Expression> get expressions => _expressions;

  // for `operator []` and `operator []=`
  @override
  void visitIndexExpression(IndexExpression node) {
    super.visitIndexExpression(node);

    final targetType = node.target?.staticType;
    final mapType = _getMapType(targetType);
    if (mapType == null) {
      return;
    }

    final indexType = node.index.staticType;
    if (indexType == null) {
      return;
    }

    final indexTypeIsSubClassOfMapKeyType =
        indexType.asInstanceOf(mapType.keyElement) != null;
    if (!indexTypeIsSubClassOfMapKeyType) {
      _expressions.add(node);
    }
  }

  // for things like `map.containsKey`
  @override
  void visitMethodInvocation(MethodInvocation node) {
    super.visitMethodInvocation(node);

    final argType = node.argumentList.arguments.singleOrNull?.staticType;

    switch (node.methodName.name) {
      case 'containsKey':
      case 'remove':
        final mapType = _getMapType(node.target?.staticType);
        _addIfNotSubType(argType, mapType?.keyElement, node);
        break;
      case 'containsValue':
        final mapType = _getMapType(node.target?.staticType);
        _addIfNotSubType(argType, mapType?.valueElement, node);
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
    MethodInvocation node,
  ) {
    if (parentElement != null &&
        childType != null &&
        childType.asInstanceOf(parentElement) == null) {
      _expressions.add(node);
    }
  }

  _MapType? _getMapType(DartType? type) {
    if (type == null || !isMapOrSubclass(type) || type is! ParameterizedType) {
      return null;
    }

    final typeArguments = type.typeArguments;
    if (typeArguments.length != 2) {
      return null;
    }

    final keyType = typeArguments.first;
    final valueType = typeArguments[1];

    final keyElement = keyType.element;
    final valueElement = valueType.element;
    if (keyElement is! ClassElement || valueElement is! ClassElement) {
      return null;
    }

    return _MapType(keyType, valueType, keyElement, valueElement);
  }

  ClassElement? _getIterableTypeElement(DartType? type) {
    if (type == null ||
        !isIterableOrSubclass(type) ||
        type is! ParameterizedType) {
      return null;
    }

    final typeArgElement = type.typeArguments.singleOrNull?.element;
    if (typeArgElement is! ClassElement) {
      return null;
    }

    return typeArgElement;
  }
}

class _MapType {
  final DartType keyType;
  final DartType valueType;

  final ClassElement keyElement;
  final ClassElement valueElement;

  _MapType(this.keyType, this.valueType, this.keyElement, this.valueElement);
}
