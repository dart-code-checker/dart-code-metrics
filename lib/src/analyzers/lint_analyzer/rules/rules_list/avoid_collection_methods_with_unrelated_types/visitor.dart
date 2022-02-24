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

    final indexTypeIsSubClassOfMapKeyType = indexType.asInstanceOf(mapType.keyElement) != null;
    if (!indexTypeIsSubClassOfMapKeyType) {
      _expressions.add(node);
    }
  }

  // for things like `map.containsKey`
  @override
  void visitMethodInvocation(MethodInvocation node) {
    super.visitMethodInvocation(node);

    switch (node.methodName.name) {
      case 'containsKey':
      case 'remove':
        final mapType = _getMapType(node.target?.staticType);
        final argType = node.argumentList.arguments.singleOrNull?.staticType;
        if(mapType != null && argType != null && argType.asInstanceOf(mapType.keyElement) == null) {
          _expressions.add(node);
        }
        break;
      case 'containsValue':
        final mapType = _getMapType(node.target?.staticType);
        final argType = node.argumentList.arguments.singleOrNull?.staticType;
        if(mapType != null && argType != null && argType.asInstanceOf(mapType.valueElement) == null) {
          _expressions.add(node);
        }
        break;
    }
  }

  _MapType? _getMapType(DartType? type) {
    if (type == null || !type.isDartCoreMap || type is! ParameterizedType) {
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
}

class _MapType {
  final DartType keyType;
  final DartType valueType;

  final ClassElement keyElement;
  final ClassElement valueElement;

  _MapType(this.keyType, this.valueType, this.keyElement, this.valueElement);
}
