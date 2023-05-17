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
      final arguments = node.typeArguments?.arguments;
      final isWhereTypeHasGeneric = arguments?.isNotEmpty ?? false;

      if (isTargetTypeHasGeneric &&
          isWhereTypeHasGeneric &&
          _isUselessTypeCheck(
            targetType.typeArguments.first,
            arguments?.first.type,
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

    if (node.notOperator != null) {
      if (objectType != null &&
          objectType is! TypeParameterType &&
          // ignore: deprecated_member_use
          !objectType.isDynamic &&
          !objectType.isDartCoreObject &&
          _isUselessTypeCheck(castedType, objectType, true)) {
        _expressions[node] =
            '${node.isOperator.keyword?.lexeme ?? ''}${node.notOperator ?? ''}';
      }
    }

    if (_isUselessTypeCheck(objectType, castedType)) {
      _expressions[node] =
          '${node.isOperator.keyword?.lexeme ?? ''}${node.notOperator ?? ''}';
    }
  }

  bool _isUselessTypeCheck(
    DartType? objectType,
    DartType? castedType, [
    bool isReversed = false,
  ]) {
    if (objectType == null || castedType == null) {
      return false;
    }

    if (_checkNullableCompatibility(objectType, castedType)) {
      return false;
    }

    final objectCastedType =
        _foundCastedTypeInObjectTypeHierarchy(objectType, castedType);
    if (objectCastedType == null) {
      return isReversed;
    }

    if (!_checkGenerics(objectCastedType, castedType)) {
      return false;
    }

    return !isReversed;
  }

  bool _checkNullableCompatibility(DartType objectType, DartType castedType) {
    final isObjectTypeNullable = isNullableType(objectType);
    final isCastedTypeNullable = isNullableType(castedType);

    // Only one case `Type? is Type` always valid assertion case.
    return isObjectTypeNullable && !isCastedTypeNullable;
  }

  DartType? _foundCastedTypeInObjectTypeHierarchy(
    DartType objectType,
    DartType castedType,
  ) {
    // ignore: deprecated_member_use
    if (objectType.element2 == castedType.element2) {
      return objectType;
    }

    if (objectType is InterfaceType) {
      return objectType.allSupertypes
          // ignore: deprecated_member_use
          .firstWhereOrNull((value) => value.element2 == castedType.element2);
    }

    return null;
  }

  bool _checkGenerics(DartType objectType, DartType castedType) {
    if (objectType is! ParameterizedType || castedType is! ParameterizedType) {
      return false;
    }

    final length = objectType.typeArguments.length;
    if (length != castedType.typeArguments.length) {
      return false;
    }

    for (var argumentIndex = 0; argumentIndex < length; argumentIndex++) {
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
