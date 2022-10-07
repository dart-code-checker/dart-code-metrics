// ignore_for_file: deprecated_member_use

part of 'avoid_unrelated_type_assertions_rule.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final _expressions = <IsExpression, String>{};

  Map<IsExpression, String> get expressions => _expressions;

  @override
  void visitIsExpression(IsExpression node) {
    super.visitIsExpression(node);

    final castedType = node.type.type;
    if (node.notOperator != null || castedType is TypeParameterType) {
      return;
    }

    final objectType = node.expression.staticType;

    if (_isUnrelatedTypeCheck(objectType, castedType)) {
      _expressions[node] =
          '${node.isOperator.keyword?.lexeme ?? ''}${node.notOperator ?? ''}';
    }
  }

  bool _isUnrelatedTypeCheck(DartType? objectType, DartType? castedType) {
    if (objectType == null || castedType == null) {
      return false;
    }

    if (objectType.isDynamic || castedType.isDynamic) {
      return false;
    }

    if (objectType is! ParameterizedType || castedType is! ParameterizedType) {
      return false;
    }

    final objectCastedType =
        _foundCastedTypeInObjectTypeHierarchy(objectType, castedType);
    final castedObjectType =
        _foundCastedTypeInObjectTypeHierarchy(castedType, objectType);
    if (objectCastedType == null && castedObjectType == null) {
      return true;
    }

    if (objectCastedType != null &&
        _checkGenerics(objectCastedType, castedType) &&
        castedObjectType != null &&
        _checkGenerics(castedObjectType, objectType)) {
      return true;
    }

    return false;
  }

  DartType? _foundCastedTypeInObjectTypeHierarchy(
    DartType objectType,
    DartType castedType,
  ) {
    if (_isFutureOrAndFuture(objectType, castedType)) {
      return objectType;
    }

    final correctObjectType =
        objectType is InterfaceType && objectType.isDartAsyncFutureOr
            ? objectType.typeArguments.first
            : objectType;

    if ((correctObjectType.element2 == castedType.element2) ||
        castedType.isDynamic ||
        correctObjectType.isDynamic ||
        _isObjectAndEnum(correctObjectType, castedType)) {
      return correctObjectType;
    }

    if (correctObjectType is InterfaceType) {
      return correctObjectType.allSupertypes
          .firstWhereOrNull((value) => value.element2 == castedType.element2);
    }

    return null;
  }

  bool _checkGenerics(DartType objectType, DartType castedType) {
    if (objectType.isDynamic || castedType.isDynamic) {
      return false;
    }

    if (objectType is! ParameterizedType || castedType is! ParameterizedType) {
      return false;
    }

    final length = objectType.typeArguments.length;
    if (length != castedType.typeArguments.length) {
      return false;
    }

    for (var argumentIndex = 0; argumentIndex < length; argumentIndex++) {
      final objectGenericType = objectType.typeArguments[argumentIndex];
      final castedGenericType = castedType.typeArguments[argumentIndex];

      if (_isUnrelatedTypeCheck(objectGenericType, castedGenericType) &&
          _isUnrelatedTypeCheck(castedGenericType, objectGenericType)) {
        return true;
      }
    }

    return false;
  }

  bool _isFutureOrAndFuture(DartType objectType, DartType castedType) =>
      objectType.isDartAsyncFutureOr && castedType.isDartAsyncFuture;

  bool _isObjectAndEnum(DartType objectType, DartType castedType) =>
      objectType.isDartCoreObject &&
      castedType.element2?.kind == ElementKind.ENUM;
}
