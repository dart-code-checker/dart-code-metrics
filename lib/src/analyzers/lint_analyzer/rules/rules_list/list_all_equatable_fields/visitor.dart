part of 'list_all_equatable_fields_rule.dart';

class _Visitor extends GeneralizingAstVisitor<void> {
  final _declarations = <_DeclarationInfo>[];

  Iterable<_DeclarationInfo> get declarations => _declarations;

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    final classType = node.extendsClause?.superclass.type;
    if (!_isEquatableOrSubclass(classType)) {
      return;
    }

    final fieldNames = node.members
        .whereType<FieldDeclaration>()
        .map((declaration) =>
            declaration.fields.variables.firstOrNull?.name.lexeme)
        .whereNotNull()
        .toSet();

    final props = node.members.firstWhereOrNull((declaration) =>
        declaration is MethodDeclaration &&
        declaration.isGetter &&
        declaration.name.lexeme == 'props') as MethodDeclaration?;

    if (props == null) {
      return;
    }

    final body = props.body;
    if (body is ExpressionFunctionBody) {
      final expression = body.expression;
      if (expression is ListLiteral) {
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
  }

  bool _isEquatableOrSubclass(DartType? type) =>
      _isEquatable(type) || _isSubclassOfEquatable(type);

  bool _isSubclassOfEquatable(DartType? type) =>
      type is InterfaceType && type.allSupertypes.any(_isEquatable);

  bool _isEquatable(DartType? type) =>
      type?.getDisplayString(withNullability: false) == 'Equatable';
}

class _DeclarationInfo {
  final Declaration node;
  final String errorMessage;

  const _DeclarationInfo(this.node, this.errorMessage);
}
