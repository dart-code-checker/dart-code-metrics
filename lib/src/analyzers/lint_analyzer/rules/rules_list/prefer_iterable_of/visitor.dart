// ignore_for_file: deprecated_member_use

part of 'prefer_iterable_of_rule.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final _expressions = <InstanceCreationExpression>[];

  Iterable<InstanceCreationExpression> get expressions => _expressions;

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    super.visitInstanceCreationExpression(node);

    if (isIterableOrSubclass(node.staticType) &&
        node.constructorName.name?.name == 'from') {
      final arg = node.argumentList.arguments.first;

      final argumentType = _getType(arg.staticType);
      final castedType = _getType(node.staticType);

      if (argumentType != null &&
          !argumentType.isDartCoreObject &&
          !argumentType.isDynamic &&
          _isUnnecessaryTypeCheck(castedType, argumentType)) {
        _expressions.add(node);
      }
    }
  }

  DartType? _getType(DartType? type) {
    if (type == null || type is! InterfaceType) {
      return null;
    }

    final typeArgument = type.typeArguments.firstOrNull;
    if (typeArgument == null) {
      return null;
    }

    return typeArgument;
  }

  bool _isUnnecessaryTypeCheck(
    DartType? objectType,
    DartType? castedType,
  ) {
    if (objectType == null || castedType == null) {
      return false;
    }

    if (objectType == castedType) {
      return true;
    }

    if (_checkNullableCompatibility(objectType, castedType)) {
      return false;
    }

    final objectCastedType =
        _foundCastedTypeInObjectTypeHierarchy(objectType, castedType);
    if (objectCastedType == null) {
      return true;
    }

    if (!_checkGenerics(objectCastedType, castedType)) {
      return false;
    }

    return false;
  }

  bool _checkNullableCompatibility(DartType objectType, DartType castedType) {
    final isObjectTypeNullable =
        objectType.nullabilitySuffix != NullabilitySuffix.none;
    final isCastedTypeNullable =
        castedType.nullabilitySuffix != NullabilitySuffix.none;

    // Only one case `Type? is Type` always valid assertion case.
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

    final length = objectType.typeArguments.length;
    if (length != castedType.typeArguments.length) {
      return false;
    }

    for (var argumentIndex = 0; argumentIndex < length; argumentIndex++) {
      if (!_isUnnecessaryTypeCheck(
        objectType.typeArguments[argumentIndex],
        castedType.typeArguments[argumentIndex],
      )) {
        return false;
      }
    }

    return true;
  }
}
