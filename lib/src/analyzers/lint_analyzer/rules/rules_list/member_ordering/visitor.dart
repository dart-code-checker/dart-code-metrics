part of 'member_ordering_rule.dart';

class _Visitor extends RecursiveAstVisitor<List<_MemberInfo>> {
  final List<_MemberGroup> _groupsOrder;
  final List<_MemberGroup> _widgetsGroupsOrder;

  final _membersInfo = <_MemberInfo>[];

  _Visitor(this._groupsOrder, this._widgetsGroupsOrder);

  @override
  List<_MemberInfo> visitClassDeclaration(ClassDeclaration node) {
    super.visitClassDeclaration(node);

    _membersInfo.clear();

    final type = node.extendsClause?.superclass.type;
    final isFlutterWidget =
        isWidgetOrSubclass(type) || isWidgetStateOrSubclass(type);

    for (final member in node.members) {
      if (member is FieldDeclaration) {
        _visitFieldDeclaration(member, isFlutterWidget);
      } else if (member is ConstructorDeclaration) {
        _visitConstructorDeclaration(member, isFlutterWidget);
      } else if (member is MethodDeclaration) {
        _visitMethodDeclaration(member, isFlutterWidget);
      }
    }

    return _membersInfo;
  }

  void _visitFieldDeclaration(
    FieldDeclaration declaration,
    bool isFlutterWidget,
  ) {
    final group = _FieldMemberGroup.parse(declaration);
    final closestGroup = _getClosestGroup(group, isFlutterWidget);

    if (closestGroup != null) {
      _membersInfo.add(_MemberInfo(
        classMember: declaration,
        memberOrder: _getOrder(
          closestGroup,
          declaration.fields.variables.first.name.lexeme,
          declaration.fields.type?.type
                  ?.getDisplayString(withNullability: false) ??
              '_',
          isFlutterWidget,
        ),
      ));
    }
  }

  void _visitConstructorDeclaration(
    ConstructorDeclaration declaration,
    bool isFlutterWidget,
  ) {
    final group = _ConstructorMemberGroup.parse(declaration);
    final closestGroup = _getClosestGroup(group, isFlutterWidget);

    if (closestGroup != null) {
      _membersInfo.add(_MemberInfo(
        classMember: declaration,
        memberOrder: _getOrder(
          closestGroup,
          declaration.name?.lexeme ?? '',
          declaration.returnType.name,
          isFlutterWidget,
        ),
      ));
    }
  }

  void _visitMethodDeclaration(
    MethodDeclaration declaration,
    bool isFlutterWidget,
  ) {
    if (declaration.isGetter || declaration.isSetter) {
      final group = _GetSetMemberGroup.parse(declaration);
      final closestGroup = _getClosestGroup(group, isFlutterWidget);

      if (closestGroup != null) {
        _membersInfo.add(_MemberInfo(
          classMember: declaration,
          memberOrder: _getOrder(
            closestGroup,
            declaration.name.lexeme,
            declaration.returnType?.type
                    ?.getDisplayString(withNullability: false) ??
                '_',
            isFlutterWidget,
          ),
        ));
      }
    } else {
      final group = _MethodMemberGroup.parse(declaration);
      final closestGroup = _getClosestGroup(group, isFlutterWidget);

      if (closestGroup != null) {
        _membersInfo.add(_MemberInfo(
          classMember: declaration,
          memberOrder: _getOrder(
            closestGroup,
            declaration.name.lexeme,
            declaration.returnType?.type
                    ?.getDisplayString(withNullability: false) ??
                '_',
            isFlutterWidget,
          ),
        ));
      }
    }
  }

  _MemberGroup? _getClosestGroup(
    _MemberGroup parsedGroup,
    bool isFlutterWidget,
  ) {
    final closestGroups = (isFlutterWidget ? _widgetsGroupsOrder : _groupsOrder)
        .where(
          (group) =>
              _isConstructorGroup(group, parsedGroup) ||
              _isFieldGroup(group, parsedGroup) ||
              _isGetSetGroup(group, parsedGroup) ||
              _isMethodGroup(group, parsedGroup),
        )
        .sorted(
          (a, b) => b.getSortingCoefficient() - a.getSortingCoefficient(),
        );

    return closestGroups.firstOrNull;
  }

  _MemberOrder _getOrder(
    _MemberGroup memberGroup,
    String memberName,
    String typeName,
    bool isFlutterWidget,
  ) {
    if (_membersInfo.isNotEmpty) {
      final lastMemberOrder = _membersInfo.last.memberOrder;
      final hasSameGroup = lastMemberOrder.memberGroup == memberGroup;

      final previousMemberGroup =
          hasSameGroup && lastMemberOrder.previousMemberGroup != null
              ? lastMemberOrder.previousMemberGroup
              : lastMemberOrder.memberGroup;

      final memberNames = _MemberNames(
        currentName: memberName,
        previousName: lastMemberOrder.memberNames.currentName,
        currentTypeName: typeName,
        previousTypeName: lastMemberOrder.memberNames.currentTypeName,
      );

      return _MemberOrder(
        memberNames: memberNames,
        isAlphabeticallyWrong: hasSameGroup &&
            memberNames.currentName.compareTo(memberNames.previousName!) < 0,
        isByTypeWrong: hasSameGroup &&
            memberNames.currentTypeName
                    .toLowerCase()
                    .compareTo(memberNames.previousTypeName!.toLowerCase()) <
                0,
        memberGroup: memberGroup,
        previousMemberGroup: previousMemberGroup,
        isWrong: (hasSameGroup && lastMemberOrder.isWrong) ||
            _isCurrentGroupBefore(
              lastMemberOrder.memberGroup,
              memberGroup,
              isFlutterWidget,
            ),
      );
    }

    return _MemberOrder(
      memberNames:
          _MemberNames(currentName: memberName, currentTypeName: typeName),
      isAlphabeticallyWrong: false,
      isByTypeWrong: false,
      memberGroup: memberGroup,
      isWrong: false,
    );
  }

  bool _isCurrentGroupBefore(
    _MemberGroup lastMemberGroup,
    _MemberGroup memberGroup,
    bool isFlutterWidget,
  ) {
    final group = isFlutterWidget ? _widgetsGroupsOrder : _groupsOrder;

    return group.indexOf(lastMemberGroup) > group.indexOf(memberGroup);
  }

  bool _isConstructorGroup(_MemberGroup group, _MemberGroup parsedGroup) =>
      group is _ConstructorMemberGroup &&
      parsedGroup is _ConstructorMemberGroup &&
      (!group.isFactory || group.isFactory == parsedGroup.isFactory) &&
      (!group.isNamed || group.isNamed == parsedGroup.isNamed) &&
      (group.modifier == _Modifier.unset ||
          group.modifier == parsedGroup.modifier) &&
      (group.annotation == _Annotation.unset ||
          group.annotation == parsedGroup.annotation);

  bool _isMethodGroup(_MemberGroup group, _MemberGroup parsedGroup) =>
      group is _MethodMemberGroup &&
      parsedGroup is _MethodMemberGroup &&
      (!group.isStatic || group.isStatic == parsedGroup.isStatic) &&
      (!group.isNullable || group.isNullable == parsedGroup.isNullable) &&
      (group.name == null || group.name == parsedGroup.name) &&
      (group.modifier == _Modifier.unset ||
          group.modifier == parsedGroup.modifier) &&
      (group.annotation == _Annotation.unset ||
          group.annotation == parsedGroup.annotation);

  bool _isGetSetGroup(_MemberGroup group, _MemberGroup parsedGroup) =>
      group is _GetSetMemberGroup &&
      parsedGroup is _GetSetMemberGroup &&
      (group.memberType == parsedGroup.memberType ||
          (group.memberType == _MemberType.getterAndSetter &&
              (parsedGroup.memberType == _MemberType.getter ||
                  parsedGroup.memberType == _MemberType.setter))) &&
      (!group.isStatic || group.isStatic == parsedGroup.isStatic) &&
      (!group.isNullable || group.isNullable == parsedGroup.isNullable) &&
      (group.modifier == _Modifier.unset ||
          group.modifier == parsedGroup.modifier) &&
      (group.annotation == _Annotation.unset ||
          group.annotation == parsedGroup.annotation);

  bool _isFieldGroup(_MemberGroup group, _MemberGroup parsedGroup) =>
      group is _FieldMemberGroup &&
      parsedGroup is _FieldMemberGroup &&
      (!group.isLate || group.isLate == parsedGroup.isLate) &&
      (!group.isStatic || group.isStatic == parsedGroup.isStatic) &&
      (!group.isNullable || group.isNullable == parsedGroup.isNullable) &&
      (group.modifier == _Modifier.unset ||
          group.modifier == parsedGroup.modifier) &&
      (group.keyword == _FieldKeyword.unset ||
          group.keyword == parsedGroup.keyword) &&
      (group.annotation == _Annotation.unset ||
          group.annotation == parsedGroup.annotation);
}

class _MemberInfo {
  final ClassMember classMember;
  final _MemberOrder memberOrder;

  const _MemberInfo({
    required this.classMember,
    required this.memberOrder,
  });
}

class _MemberOrder {
  final bool isWrong;
  final bool isAlphabeticallyWrong;
  final bool isByTypeWrong;
  final _MemberNames memberNames;
  final _MemberGroup memberGroup;
  final _MemberGroup? previousMemberGroup;

  const _MemberOrder({
    required this.isWrong,
    required this.isAlphabeticallyWrong,
    required this.isByTypeWrong,
    required this.memberNames,
    required this.memberGroup,
    this.previousMemberGroup,
  });
}

class _MemberNames {
  final String currentName;
  final String? previousName;
  final String currentTypeName;
  final String? previousTypeName;

  const _MemberNames({
    required this.currentName,
    required this.currentTypeName,
    this.previousName,
    this.previousTypeName,
  });
}
