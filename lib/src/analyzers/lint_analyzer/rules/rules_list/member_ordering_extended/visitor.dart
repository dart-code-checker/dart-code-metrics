part of 'member_ordering_extended.dart';

class _Visitor extends RecursiveAstVisitor<List<_MemberInfo>> {
  final List<_MemberGroup> _groupsOrder;

  final _membersInfo = <_MemberInfo>[];

  _Visitor(this._groupsOrder);

  @override
  List<_MemberInfo> visitClassDeclaration(ClassDeclaration node) {
    super.visitClassDeclaration(node);

    _membersInfo.clear();

    for (final member in node.members) {
      if (member is FieldDeclaration) {
        _visitFieldDeclaration(member);
      } else if (member is ConstructorDeclaration) {
        _visitConstructorDeclaration(member);
      } else if (member is MethodDeclaration) {
        _visitMethodDeclaration(member);
      }
    }

    return _membersInfo;
  }

  void _visitFieldDeclaration(FieldDeclaration declaration) {
    final group = _FieldMemberGroup.parse(declaration);
    final closestGroup = _getClosestGroup(group);

    if (closestGroup != null) {
      _membersInfo.add(_MemberInfo(
        classMember: declaration,
        memberOrder: _getOrder(
          closestGroup,
          declaration.fields.variables.first.name.name,
        ),
      ));
    }
  }

  void _visitConstructorDeclaration(ConstructorDeclaration declaration) {
    final group = _ConstructorMemberGroup.parse(declaration);
    final closestGroup = _getClosestGroup(group);

    if (closestGroup != null) {
      _membersInfo.add(_MemberInfo(
        classMember: declaration,
        memberOrder: _getOrder(closestGroup, declaration.name?.name ?? ''),
      ));
    }
  }

  void _visitMethodDeclaration(MethodDeclaration declaration) {
    if (declaration.isGetter || declaration.isSetter) {
      final group = _GetSetMemberGroup.parse(declaration);
      final closestGroup = _getClosestGroup(group);

      if (closestGroup != null) {
        _membersInfo.add(_MemberInfo(
          classMember: declaration,
          memberOrder: _getOrder(closestGroup, declaration.name.name),
        ));
      }
    } else {
      final group = _MethodMemberGroup.parse(declaration);
      final closestGroup = _getClosestGroup(group);

      if (closestGroup != null) {
        _membersInfo.add(_MemberInfo(
          classMember: declaration,
          memberOrder: _getOrder(closestGroup, declaration.name.name),
        ));
      }
    }
  }

  _MemberGroup? _getClosestGroup(_MemberGroup parsedGroup) {
    final closestGroups = _groupsOrder
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

  _MemberOrder _getOrder(_MemberGroup memberGroup, String memberName) {
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
      );

      return _MemberOrder(
        memberNames: memberNames,
        isAlphabeticallyWrong: hasSameGroup &&
            memberNames.currentName.compareTo(memberNames.previousName!) < 0,
        memberGroup: memberGroup,
        previousMemberGroup: previousMemberGroup,
        isWrong: (hasSameGroup && lastMemberOrder.isWrong) ||
            _isCurrentGroupBefore(lastMemberOrder.memberGroup, memberGroup),
      );
    }

    return _MemberOrder(
      memberNames: _MemberNames(currentName: memberName),
      isAlphabeticallyWrong: false,
      memberGroup: memberGroup,
      isWrong: false,
    );
  }

  bool _isCurrentGroupBefore(
    _MemberGroup lastMemberGroup,
    _MemberGroup memberGroup,
  ) =>
      _groupsOrder.indexOf(lastMemberGroup) > _groupsOrder.indexOf(memberGroup);

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

@immutable
class _MemberInfo {
  final ClassMember classMember;
  final _MemberOrder memberOrder;

  const _MemberInfo({
    required this.classMember,
    required this.memberOrder,
  });
}

@immutable
class _MemberOrder {
  final bool isWrong;
  final bool isAlphabeticallyWrong;
  final _MemberNames memberNames;
  final _MemberGroup memberGroup;
  final _MemberGroup? previousMemberGroup;

  const _MemberOrder({
    required this.isWrong,
    required this.isAlphabeticallyWrong,
    required this.memberNames,
    required this.memberGroup,
    this.previousMemberGroup,
  });
}

@immutable
class _MemberNames {
  final String currentName;
  final String? previousName;

  const _MemberNames({
    required this.currentName,
    this.previousName,
  });
}
