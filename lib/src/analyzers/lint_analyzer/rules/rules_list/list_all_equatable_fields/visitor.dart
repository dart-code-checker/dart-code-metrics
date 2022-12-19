part of 'list_all_equatable_fields_rule.dart';

class _Visitor extends GeneralizingAstVisitor<void> {
  final _declarations = <_DeclarationInfo>[];

  Iterable<_DeclarationInfo> get declarations => _declarations;

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    final classType = node.extendsClause?.superclass.type;

    final isEquatable = _isEquatableOrSubclass(classType);
    final isMixin = node.withClause?.mixinTypes
            .any((mixinType) => _isEquatableMixin(mixinType.type)) ??
        false;
    final isSubclassOfMixin = _isSubclassOfEquatableMixin(classType);
    if (!isEquatable && !isMixin && !isSubclassOfMixin) {
      return;
    }

    final fieldNames = node.members
        .whereType<FieldDeclaration>()
        .whereNot((field) => field.isStatic)
        .map((declaration) =>
            declaration.fields.variables.firstOrNull?.name.lexeme)
        .whereNotNull()
        .toSet();

    if (isMixin) {
      fieldNames.addAll(_getParentFields(classType));
    }

    final props = node.members.firstWhereOrNull((declaration) =>
        declaration is MethodDeclaration &&
        declaration.isGetter &&
        declaration.name.lexeme == 'props') as MethodDeclaration?;

    if (props == null) {
      return;
    }

    final literalVisitor = _ListLiteralVisitor();
    props.body.visitChildren(literalVisitor);

    final expression = literalVisitor.literals.firstOrNull;
    if (expression != null) {
      final usedFields = expression.elements
          .whereType<SimpleIdentifier>()
          .map((identifier) => identifier.name)
          .toSet();

      if (!usedFields.containsAll(fieldNames)) {
        final missingFields = fieldNames.difference(usedFields).join(', ');
        _declarations.add(_DeclarationInfo(
          props,
          'Missing declared class fields: $missingFields',
        ));
      }
    }
  }

  Set<String> _getParentFields(DartType? classType) {
    // ignore: deprecated_member_use
    final element = classType?.element2;
    if (element is! ClassElement) {
      return {};
    }

    return element.fields
        .where(
          (field) =>
              !field.isStatic &&
              !field.isConst &&
              !field.isPrivate &&
              field.name != 'hashCode',
        )
        .map((field) => field.name)
        .toSet();
  }

  bool _isEquatableOrSubclass(DartType? type) =>
      _isEquatable(type) || _isSubclassOfEquatable(type);

  bool _isSubclassOfEquatable(DartType? type) =>
      type is InterfaceType && type.allSupertypes.any(_isEquatable);

  bool _isEquatable(DartType? type) =>
      type?.getDisplayString(withNullability: false) == 'Equatable';

  bool _isEquatableMixin(DartType? type) =>
      // ignore: deprecated_member_use
      type?.element2 is MixinElement &&
      type?.getDisplayString(withNullability: false) == 'EquatableMixin';

  bool _isSubclassOfEquatableMixin(DartType? type) {
    // ignore: deprecated_member_use
    final element = type?.element2;

    return element is ClassElement && element.mixins.any(_isEquatableMixin);
  }
}

class _ListLiteralVisitor extends RecursiveAstVisitor<void> {
  final literals = <ListLiteral>{};

  @override
  void visitListLiteral(ListLiteral node) {
    super.visitListLiteral(node);

    literals.add(node);
  }
}

class _DeclarationInfo {
  final Declaration node;
  final String errorMessage;

  const _DeclarationInfo(this.node, this.errorMessage);
}
