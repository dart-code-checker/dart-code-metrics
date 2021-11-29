part of 'avoid_unnecessary_type_assertions_rule.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final _expressions = <Expression, String>{};

  Map<Expression, String> get expressions => _expressions;

  @override
  void visitMethodInvocation(MethodInvocation node) {
    super.visitMethodInvocation(node);

    const methodName = 'whereType';

    final isTargetIterable = isIterableOrSubclass(node.realTarget?.staticType);
    final isWhereTypeInvocation = node.methodName.name == methodName;
    final targetType = node.target?.staticType;

    if (isTargetIterable &&
        isWhereTypeInvocation &&
        targetType is ParameterizedType) {
      final isTargetTypeHasGeneric = targetType.typeArguments.isNotEmpty;
      final isWhereTypeHasGeneric =
          node.typeArguments?.arguments.isNotEmpty ?? false;

      if (isTargetTypeHasGeneric &&
          isWhereTypeHasGeneric &&
          _isUselessTypeCheck(
            targetType.typeArguments.first,
            node.typeArguments?.arguments.first.type,
          )) {
        _expressions[node] =
            '${node.methodName}${node.typeArguments ?? ''}${node.argumentList}';
      }
    }
  }

  @override
  void visitIsExpression(IsExpression node) {
    super.visitIsExpression(node);

    final objectType = node.expression.staticType;
    final castedType = node.type.type;
    if (_isUselessTypeCheck(objectType, castedType)) {
      _expressions[node] =
          '${node.isOperator.keyword?.lexeme ?? ''}${node.notOperator ?? ''}';
    }
  }

  bool _isUselessTypeCheck(DartType? objectType, DartType? castedType) {
    if (objectType == null || castedType == null) {
      return false;
    }

    if (_checkNullableCompatibility(objectType, castedType)) {
      return false;
    }

    final objectCastedType =
        _foundCastedTypeInObjectTypeHierarchy(objectType, castedType);
    if (objectCastedType == null) {
      return false;
    }

    if (!_checkGenerics(objectCastedType, castedType)) {
      return false;
    }

    return true;
  }

  bool _checkNullableCompatibility(DartType objectType, DartType castedType) {
    final isObjectTypeNullable =
        objectType.nullabilitySuffix != NullabilitySuffix.none;
    final isCastedTypeNullable =
        castedType.nullabilitySuffix != NullabilitySuffix.none;

    // Only one case `Type? is Type` always valid assertion case
    return isObjectTypeNullable && !isCastedTypeNullable;
  }

  DartType? _foundCastedTypeInObjectTypeHierarchy(
    DartType objectType,
    DartType castedType,
  ) {
    if (objectType.element == castedType.element) {
      return objectType;
    }

    if (objectType is InterfaceType) {
      return objectType.allSupertypes
          .firstWhereOrNull((value) => value.element == castedType.element);
    }

    return null;
  }

  bool _checkGenerics(DartType objectType, DartType castedType) {
    if (objectType is! ParameterizedType || castedType is! ParameterizedType) {
      return false;
    }

    if (objectType.typeArguments.length != castedType.typeArguments.length) {
      return false;
    }

    for (var argumentIndex = 0;
        argumentIndex < objectType.typeArguments.length;
        argumentIndex++) {
      if (!_isUselessTypeCheck(
        objectType.typeArguments[argumentIndex],
        castedType.typeArguments[argumentIndex],
      )) {
        return false;
      }
    }

    return true;
  }
}
