part of 'avoid_collection_methods_with_unrelated_types_rule.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final _expressions = <Expression>[];

  Iterable<Expression> get expressions => _expressions;

  @override
  void visitIndexExpression(IndexExpression node) {
    super.visitIndexExpression(node);

    final targetType = node.target?.staticType;
    final mapKeyType = _getMapKeyType(targetType);
    if (mapKeyType == null) {
      return;
    }

    final mapKeyElement = mapKeyType.element;
    if (mapKeyElement is! ClassElement) {
      return;
    }

    final indexType = node.index.staticType;
    if (indexType == null) {
      return;
    }

    final indexTypeIsSubClassOfMapKeyType = indexType.asInstanceOf(mapKeyElement) != null;
    if (!indexTypeIsSubClassOfMapKeyType) {
      _expressions.add(node);
    }
  }

  DartType? _getMapKeyType(DartType? type) {
    if (type == null || !type.isDartCoreMap || type is! ParameterizedType) {
      return null;
    }

    final typeArguments = type.typeArguments;
    if (typeArguments.length != 2) {
      return null;
    }

    return typeArguments.first;
  }
}
