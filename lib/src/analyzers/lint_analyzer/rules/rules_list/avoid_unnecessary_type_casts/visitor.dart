part of 'avoid_unnecessary_type_casts_rule.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final _expressions = <Expression, String>{};

  Map<Expression, String> get expressions => _expressions;

  @override
  void visitAsExpression(AsExpression node) {
    super.visitAsExpression(node);

    final objectType = node.expression.staticType;
    final castedType = node.type.type;
    if (_isUselessTypeCheck(objectType, castedType)) {
      _expressions[node] = 'as';
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
