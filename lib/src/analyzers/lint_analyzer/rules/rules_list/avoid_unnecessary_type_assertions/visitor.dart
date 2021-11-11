part of 'avoid_unnecessary_type_assertions_rule.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final _expressions = <Expression, String>{};

  Map<Expression, String> get expressions => _expressions;

  @override
  void visitMethodInvocation(MethodInvocation node) {
    super.visitMethodInvocation(node);

    const methodName = 'whereType';

    final isWhereTypeFunction = node.methodName.name == methodName;
    if (isIterableOrSubclass(node.realTarget?.staticType) &&
        isWhereTypeFunction &&
        node.target?.staticType is InterfaceType) {
      final interfaceType = node.target?.staticType as InterfaceType;
      final isTypeHasGeneric = interfaceType.typeArguments.isNotEmpty;

      final isCastedHasGeneric =
          node.typeArguments?.arguments.isNotEmpty ?? false;
      if (isTypeHasGeneric &&
          isCastedHasGeneric &&
          _isUselessTypeCheck(
            interfaceType.typeArguments.first,
            node.typeArguments?.arguments.first.type,
          )) {
        _expressions[node] = methodName;
      }
    }
  }

  @override
  void visitIsExpression(IsExpression node) {
    final objectType = node.expression.staticType;
    final castedType = node.type.type;
    if (_isUselessTypeCheck(objectType, castedType)) {
      _expressions[node] = 'is';
    }
  }

  bool _isUselessTypeCheck(
    DartType? objectType,
    DartType? castedType,
  ) {
    if (objectType == null || castedType == null) {
      return false;
    }

    // Checked type name
    final typeName = objectType.getDisplayString(withNullability: true);
    // Casted type name with nullability
    final castedNameNull = castedType.getDisplayString(withNullability: true);
    // Casted type name without nullability
    final castedName = castedType.getDisplayString(withNullability: false);
    // Validation checks
    final isTypeSame = '$typeName?' == castedNameNull || typeName == castedName;
    final isTypeInheritor = _isInheritorType(objectType, castedNameNull);

    final isTypeWithGeneric = objectType is InterfaceType &&
        castedType is InterfaceType &&
        _isTypeWithGeneric(objectType, castedType);

    return isTypeSame || isTypeInheritor || isTypeWithGeneric;
  }

  bool _isTypeWithGeneric(InterfaceType objectType, InterfaceType castedType) {
    final objectTypeArguments = objectType.typeArguments;
    final castedTypeArguments = castedType.typeArguments;
    final isHasGeneric = objectTypeArguments.isNotEmpty;
    final isCount = objectTypeArguments.length == castedTypeArguments.length;

    if (isHasGeneric && isCount) {
      if (castedType.element.name == objectType.element.name) {
        for (var i = 0; i < objectTypeArguments.length; i++) {
          final isCheckUseless = _isUselessTypeCheck(
            objectTypeArguments[i],
            castedTypeArguments[i],
          );
          if (!isCheckUseless) {
            return false;
          }
        }

        return true;
      }
    }

    return false;
  }

  bool _isInheritorType(DartType objectType, String castedNameNull) =>
      objectType is InterfaceType &&
      objectType.allSupertypes
          .any((value) => _isInheritor(value, castedNameNull));

  bool _isInheritor(DartType? type, String typeName) =>
      type?.getDisplayString(withNullability: false) == typeName;
}
