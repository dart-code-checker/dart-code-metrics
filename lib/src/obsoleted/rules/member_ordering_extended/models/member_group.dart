part of '../member_ordering_extended_rule.dart';

abstract class _MemberGroup {
  final _Annotation annotation;
  final _MemberType memberType;
  final _Modifier modifier;

  final String rawRepresentation;

  const _MemberGroup(
    this.annotation,
    this.memberType,
    this.modifier,
    this.rawRepresentation,
  );

  int getSortingCoefficient();
}

class _FieldMemberGroup extends _MemberGroup {
  final bool isStatic;
  final bool isNullable;
  final bool isLate;
  final _FieldKeyword keyword;

  const _FieldMemberGroup._({
    required this.isLate,
    required this.isNullable,
    required this.isStatic,
    required this.keyword,
    required _Annotation annotation,
    required _MemberType memberType,
    required _Modifier modifier,
    required String rawRepresentation,
  }) : super(
          annotation,
          memberType,
          modifier,
          rawRepresentation,
        );

  factory _FieldMemberGroup.parse(FieldDeclaration declaration) {
    final annotation = declaration.metadata
        .map((metadata) => _Annotation.parse(metadata.name.name))
        .whereNotNull()
        .firstOrNull;
    final modifier =
        Identifier.isPrivateName(declaration.fields.variables.first.name.name)
            ? _Modifier.private
            : _Modifier.public;
    final isNullable = declaration.fields.type?.type?.nullabilitySuffix ==
        NullabilitySuffix.question;
    final keyword = declaration.fields.isConst
        ? _FieldKeyword.isConst
        : declaration.fields.isFinal
            ? _FieldKeyword.isFinal
            : _FieldKeyword.unset;

    return _FieldMemberGroup._(
      annotation: annotation ?? _Annotation.unset,
      isStatic: declaration.isStatic,
      isNullable: isNullable,
      isLate: declaration.fields.isLate,
      memberType: _MemberType.field,
      modifier: modifier,
      keyword: keyword,
      rawRepresentation: '',
    );
  }

  @override
  int getSortingCoefficient() {
    var coefficient = 0;

    coefficient += isStatic ? 1 : 0;
    coefficient += isNullable ? 1 : 0;
    coefficient += isLate ? 1 : 0;
    coefficient += keyword != _FieldKeyword.unset ? 1 : 0;
    coefficient += annotation != _Annotation.unset ? 1 : 0;
    coefficient += modifier != _Modifier.unset ? 1 : 0;

    return coefficient;
  }

  @override
  String toString() => rawRepresentation;
}

class _MethodMemberGroup extends _MemberGroup {
  final bool isStatic;
  final bool isNullable;

  const _MethodMemberGroup._({
    required this.isNullable,
    required this.isStatic,
    required _Annotation annotation,
    required _MemberType memberType,
    required _Modifier modifier,
    required String rawRepresentation,
  }) : super(
          annotation,
          memberType,
          modifier,
          rawRepresentation,
        );

  factory _MethodMemberGroup.parse(MethodDeclaration declaration) {
    final annotation = declaration.metadata
        .map((metadata) => _Annotation.parse(metadata.name.name))
        .whereNotNull()
        .firstOrNull;
    final modifier = Identifier.isPrivateName(declaration.name.name)
        ? _Modifier.private
        : _Modifier.public;

    return _MethodMemberGroup._(
      annotation: annotation ?? _Annotation.unset,
      isStatic: declaration.isStatic,
      isNullable: declaration.returnType?.question != null,
      memberType: _MemberType.method,
      modifier: modifier,
      rawRepresentation: '',
    );
  }

  @override
  int getSortingCoefficient() {
    var coefficient = 0;

    coefficient += isStatic ? 1 : 0;
    coefficient += isNullable ? 1 : 0;
    coefficient += annotation != _Annotation.unset ? 1 : 0;
    coefficient += modifier != _Modifier.unset ? 1 : 0;

    return coefficient;
  }

  @override
  String toString() => rawRepresentation;
}

class _ConstructorMemberGroup extends _MemberGroup {
  final bool isNamed;
  final bool isFactory;

  const _ConstructorMemberGroup._({
    required this.isNamed,
    required this.isFactory,
    required _Annotation annotation,
    required _MemberType memberType,
    required _Modifier modifier,
    required String rawRepresentation,
  }) : super(
          annotation,
          memberType,
          modifier,
          rawRepresentation,
        );

  factory _ConstructorMemberGroup.parse(ConstructorDeclaration declaration) {
    final annotation = declaration.metadata
        .map((metadata) => _Annotation.parse(metadata.name.name))
        .whereNotNull()
        .firstOrNull;
    final name = declaration.name;
    final isFactory = declaration.factoryKeyword != null;
    final isNamed = name != null;

    final modifier = name == null
        ? _Modifier.unset
        : Identifier.isPrivateName(name.name)
            ? _Modifier.private
            : _Modifier.public;

    return _ConstructorMemberGroup._(
      isNamed: isNamed,
      isFactory: isFactory,
      annotation: annotation ?? _Annotation.unset,
      modifier: modifier,
      memberType: _MemberType.constructor,
      rawRepresentation: '',
    );
  }

  @override
  int getSortingCoefficient() {
    var coefficient = 0;

    coefficient += isNamed ? 1 : 0;
    coefficient += isFactory ? 1 : 0;
    coefficient += annotation != _Annotation.unset ? 1 : 0;
    coefficient += modifier != _Modifier.unset ? 1 : 0;

    return coefficient;
  }

  @override
  String toString() => rawRepresentation;
}

class _GetSetMemberGroup extends _MemberGroup {
  final bool isStatic;
  final bool isNullable;

  const _GetSetMemberGroup._({
    required this.isNullable,
    required this.isStatic,
    required _Annotation annotation,
    required _MemberType memberType,
    required _Modifier modifier,
    required String rawRepresentation,
  }) : super(annotation, memberType, modifier, rawRepresentation);

  factory _GetSetMemberGroup.parse(MethodDeclaration declaration) {
    final annotation = declaration.metadata
        .map((metadata) => _Annotation.parse(metadata.name.name))
        .whereNotNull()
        .firstOrNull;
    final type = declaration.isGetter ? _MemberType.getter : _MemberType.setter;
    final modifier = Identifier.isPrivateName(declaration.name.name)
        ? _Modifier.private
        : _Modifier.public;

    return _GetSetMemberGroup._(
      annotation: annotation ?? _Annotation.unset,
      isStatic: declaration.isStatic,
      isNullable: declaration.returnType?.question != null,
      memberType: type,
      modifier: modifier,
      rawRepresentation: '',
    );
  }

  @override
  int getSortingCoefficient() {
    var coefficient = 0;

    coefficient += isStatic ? 1 : 0;
    coefficient += isNullable ? 1 : 0;
    coefficient += annotation != _Annotation.unset ? 1 : 0;
    coefficient += modifier != _Modifier.unset ? 1 : 0;

    return coefficient;
  }

  @override
  String toString() => rawRepresentation;
}
