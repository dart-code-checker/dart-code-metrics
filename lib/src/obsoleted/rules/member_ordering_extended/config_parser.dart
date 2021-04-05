part of 'member_ordering_extended_rule.dart';

// ignore: avoid_classes_with_only_static_members
class _ConfigParser {
  static const _defaultOrderList = [
    'public_fields',
    'private_fields',
    'public_getters',
    'private_getters',
    'public_setters',
    'private_setters',
    'constructors',
    'public_methods',
    'private_methods',
  ];

  static final _regExp = RegExp(
    '(overridden_|protected_)?(private_|public_)?(static_)?(late_)?'
    '(var_|final_|const_)?(nullable_)?(named_)?(factory_)?',
  );

  static List<_MemberGroup> parseOrder(Map<String, Object> config) {
    final order = config.containsKey('order') && config['order'] is Iterable
        ? List<String>.from(config['order'] as Iterable)
        : _defaultOrderList;

    return order.map(_parseGroup).whereNotNull().toList();
  }

  // ignore: long-method
  static _MemberGroup? _parseGroup(String group) {
    final type = _MemberType.parse(group.split('_').lastOrNull);
    final result = _regExp.allMatches(group.toLowerCase());

    final hasGroups = result.isNotEmpty && result.first.groupCount > 0;
    if (hasGroups && type != null) {
      final match = result.first;

      final annotation = _Annotation.parse(match.group(1)?.replaceAll('_', ''));
      final modifier = _Modifier.parse(match.group(2)?.replaceAll('_', ''));
      final isStatic = match.group(3) != null;
      final isLate = match.group(4) != null;
      final keyword = _FieldKeyword.parse(match.group(5)?.replaceAll('_', ''));
      final isNullable = match.group(6) != null;
      final isNamed = match.group(7) != null;
      final isFactory = match.group(8) != null;

      switch (type) {
        case _MemberType.field:
          return _FieldMemberGroup._(
            isLate: isLate,
            isNullable: isNullable,
            isStatic: isStatic,
            keyword: keyword,
            annotation: annotation,
            memberType: type,
            modifier: modifier,
            rawRepresentation: group,
          );

        case _MemberType.method:
          return _MethodMemberGroup._(
            isNullable: isNullable,
            isStatic: isStatic,
            annotation: annotation,
            memberType: type,
            modifier: modifier,
            rawRepresentation: group,
          );

        case _MemberType.getter:
        case _MemberType.setter:
        case _MemberType.getterAndSetter:
          return _GetSetMemberGroup._(
            isNullable: isNullable,
            isStatic: isStatic,
            annotation: annotation,
            memberType: type,
            modifier: modifier,
            rawRepresentation: group,
          );

        case _MemberType.constructor:
          return _ConstructorMemberGroup._(
            isNamed: isFactory || isNamed,
            isFactory: isFactory,
            annotation: annotation,
            memberType: type,
            modifier: modifier,
            rawRepresentation: group,
          );
      }
    }

    return null;
  }
}
