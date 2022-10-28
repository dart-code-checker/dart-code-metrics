part of 'member_ordering_rule.dart';

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

  static const _defaultWidgetsOrderList = [
    'constructor',
    'named-constructor',
    'const-fields',
    'static-methods',
    'final-fields',
    'init-state-method',
    'var-fields',
    'init-state-method',
    'private-methods',
    'overridden-public-methods',
    'build-method',
  ];

  static const _orderConfig = 'order';
  static const _widgetsOrderConfig = 'widgets-order';
  static const _alphabetizeConfig = 'alphabetize';
  static const _alphabetizeByTypeConfig = 'alphabetize-by-type';

  static final _regExp = RegExp(
    '(overridden-|protected-)?(private-|public-)?(static-)?(late-)?'
    '(var-|final-|const-)?(nullable-)?(named-)?(factory-)?',
  );

  static List<_MemberGroup> parseOrder(Map<String, Object> config) {
    final order = config[_orderConfig] is Iterable
        ? List<String>.from(config[_orderConfig] as Iterable)
        : _defaultOrderList;

    return order.map(_parseGroup).whereNotNull().toList();
  }

  static List<_MemberGroup> parseWidgetsOrder(Map<String, Object> config) {
    final widgetsOrder = config[_widgetsOrderConfig] is Iterable
        ? List<String>.from(config[_widgetsOrderConfig] as Iterable)
        : _defaultWidgetsOrderList;

    return widgetsOrder.map(_parseGroup).whereNotNull().toList();
  }

  static bool parseAlphabetize(Map<String, Object> config) =>
      (config[_alphabetizeConfig] as bool?) ?? false;

  static bool parseAlphabetizeByType(Map<String, Object> config) =>
      (config[_alphabetizeByTypeConfig] as bool?) ?? false;

  // ignore: long-method
  static _MemberGroup? _parseGroup(String group) {
    final lastGroup = group.endsWith('getters-setters')
        ? 'getters-setters'
        : group.split('-').lastOrNull;
    final type = _MemberType.parse(lastGroup);
    final result = _regExp.allMatches(group.toLowerCase());

    final isNamedMethod = group.endsWith('-method');
    if (isNamedMethod) {
      final name = group.split('-method').first.replaceAll('-', '');

      return _MethodMemberGroup.named(
        name: name,
        memberType: _MemberType.method,
        rawRepresentation: group,
      );
    }

    final hasGroups = result.isNotEmpty && result.first.groupCount > 0;
    if (hasGroups && type != null) {
      final match = result.first;

      final annotation = _Annotation.parse(match.group(1)?.replaceAll('-', ''));
      final modifier = _Modifier.parse(match.group(2)?.replaceAll('-', ''));
      final isStatic = match.group(3) != null;
      final isLate = match.group(4) != null;
      final keyword = _FieldKeyword.parse(match.group(5)?.replaceAll('-', ''));
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
            name: null,
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
