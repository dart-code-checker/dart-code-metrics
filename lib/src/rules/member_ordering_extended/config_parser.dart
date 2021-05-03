part of 'member_ordering_extended_rule.dart';

// ignore: avoid_classes_with_only_static_members
class _ConfigParser {
  static const _defaultOrderList = [
    'public-fields',
    'private-fields',
    'public-getters',
    'private-getters',
    'public-setters',
    'private-setters',
    'constructors',
    'public-methods',
    'private-methods',
  ];

  static final _regExp = RegExp(
    '(overridden-|protected-)?(private-|public-)?(static-)?(late-)?'
    '(var-|final-|const-)?(nullable-)?(named-)?(factory-)?',
  );

  static List<_MemberGroup> parseOrder(Map<String, Object> config) {
    final order = config.containsKey('order') && config['order'] is Iterable
        ? List<String>.from(config['order'] as Iterable)
        : _defaultOrderList;

    return order.map(_parseGroup).where((group) => group != null).toList();
  }

  // ignore: long-method
  static _MemberGroup _parseGroup(String group) {
    final lastGroup = group.endsWith('getters-setters')
        ? 'getters-setters'
        : group.split('-').isNotEmpty
            ? group.split('-').last
            : null;
    final type = _MemberType.parse(lastGroup);
    final result = _regExp.allMatches(group.toLowerCase());

    final hasGroups = result.isNotEmpty && result.first.groupCount > 0;
    if (hasGroups && type != null) {
      final match = result.first;

      final annotation = _Annotation.parse(match.group(1)?.replaceAll('-', ''));
      final modifier = _Modifier.parse(match.group(2)?.replaceAll('-', ''));
      final isStatic = match.group(3) != null;
      final keyword = _FieldKeyword.parse(match.group(5)?.replaceAll('-', ''));
      final isNamed = match.group(7) != null;
      final isFactory = match.group(8) != null;

      switch (type) {
        case _MemberType.field:
          return _FieldMemberGroup._(
            isStatic: isStatic,
            keyword: keyword,
            annotation: annotation,
            memberType: type,
            modifier: modifier,
            rawRepresentation: group,
          );

        case _MemberType.method:
          return _MethodMemberGroup._(
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
