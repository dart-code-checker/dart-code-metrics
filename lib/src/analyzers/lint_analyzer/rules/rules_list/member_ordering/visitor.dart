part of 'member_ordering_rule.dart';

class _Visitor extends RecursiveAstVisitor<List<_MemberInfo>> {
  final List<_MembersGroup> _groupsOrder;
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

  void _visitFieldDeclaration(FieldDeclaration fieldDeclaration) {
    if (_hasMetadata(fieldDeclaration)) {
      return;
    }

    for (final variable in fieldDeclaration.fields.variables) {
      final membersGroup = Identifier.isPrivateName(variable.name.name)
          ? _MembersGroup.privateFields
          : _MembersGroup.publicFields;

      if (_groupsOrder.contains(membersGroup)) {
        _membersInfo.add(_MemberInfo(
          classMember: fieldDeclaration,
          memberOrder: _getOrder(membersGroup, variable.name.name),
        ));
      }
    }
  }

  void _visitConstructorDeclaration(
    ConstructorDeclaration constructorDeclaration,
  ) {
    if (_groupsOrder.contains(_MembersGroup.constructors)) {
      _membersInfo.add(_MemberInfo(
        classMember: constructorDeclaration,
        memberOrder: _getOrder(
          _MembersGroup.constructors,
          constructorDeclaration.name?.name ?? '',
        ),
      ));
    }
  }

  void _visitMethodDeclaration(MethodDeclaration methodDeclaration) {
    if (_hasMetadata(methodDeclaration)) {
      return;
    }

    _MembersGroup membersGroup;

    if (methodDeclaration.isGetter) {
      membersGroup = Identifier.isPrivateName(methodDeclaration.name.name)
          ? _MembersGroup.privateGetters
          : _MembersGroup.publicGetters;
    } else if (methodDeclaration.isSetter) {
      membersGroup = Identifier.isPrivateName(methodDeclaration.name.name)
          ? _MembersGroup.privateSetters
          : _MembersGroup.publicSetters;
    } else {
      membersGroup = Identifier.isPrivateName(methodDeclaration.name.name)
          ? _MembersGroup.privateMethods
          : _MembersGroup.publicMethods;
    }

    if (_groupsOrder.contains(membersGroup)) {
      _membersInfo.add(_MemberInfo(
        classMember: methodDeclaration,
        memberOrder: _getOrder(membersGroup, methodDeclaration.name.name),
      ));
    }
  }

  bool _hasMetadata(ClassMember classMember) {
    for (final data in classMember.metadata) {
      final annotation = _Annotation.parse(data.name.name);
      final memberName = classMember is FieldDeclaration
          ? classMember.fields.variables.first.name.name
          : classMember is MethodDeclaration
              ? classMember.name.name
              : '';

      if (annotation != null && _groupsOrder.contains(annotation.group)) {
        _membersInfo.add(_MemberInfo(
          classMember: classMember,
          memberOrder: _getOrder(annotation.group, memberName),
        ));

        return true;
      }
    }

    return false;
  }

  _MemberOrder _getOrder(_MembersGroup memberGroup, String memberName) {
    if (_membersInfo.isNotEmpty) {
      final lastMemberOrder = _membersInfo.last.memberOrder;
      final hasSameGroup = lastMemberOrder.memberGroup == memberGroup;

      final previousMemberGroup = hasSameGroup
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
    _MembersGroup lastMemberGroup,
    _MembersGroup memberGroup,
  ) =>
      _groupsOrder.indexOf(lastMemberGroup) > _groupsOrder.indexOf(memberGroup);
}

class _MembersGroup {
  final String name;

  // Generic
  static const publicFields = _MembersGroup._('public-fields');
  static const privateFields = _MembersGroup._('private-fields');
  static const publicGetters = _MembersGroup._('public-getters');
  static const privateGetters = _MembersGroup._('private-getters');
  static const publicSetters = _MembersGroup._('public-setters');
  static const privateSetters = _MembersGroup._('private-setters');
  static const publicMethods = _MembersGroup._('public-methods');
  static const privateMethods = _MembersGroup._('private-methods');
  static const constructors = _MembersGroup._('constructors');

  // Angular
  static const angularInputs = _MembersGroup._('angular-inputs');
  static const angularOutputs = _MembersGroup._('angular-outputs');
  static const angularHostBindings = _MembersGroup._('angular-host-bindings');
  static const angularHostListeners = _MembersGroup._('angular-host-listeners');
  static const angularViewChildren = _MembersGroup._('angular-view-children');
  static const angularContentChildren =
      _MembersGroup._('angular-content-children');

  static const _groupsOrder = [
    publicFields,
    privateFields,
    publicGetters,
    privateGetters,
    publicSetters,
    privateSetters,
    constructors,
    publicMethods,
    privateMethods,
    angularInputs,
    angularOutputs,
    angularHostBindings,
    angularHostListeners,
    angularViewChildren,
    angularContentChildren,
  ];

  const _MembersGroup._(this.name);

  static _MembersGroup? parse(String name) =>
      _groupsOrder.firstWhereOrNull((group) => group.name == name);
}

class _Annotation {
  final String name;
  final _MembersGroup group;

  static const input = _Annotation._('Input', _MembersGroup.angularInputs);
  static const output = _Annotation._('Output', _MembersGroup.angularOutputs);
  static const hostBinding =
      _Annotation._('HostBinding', _MembersGroup.angularHostBindings);
  static const hostListener =
      _Annotation._('HostListener', _MembersGroup.angularHostListeners);
  static const viewChild =
      _Annotation._('ViewChild', _MembersGroup.angularViewChildren);
  static const viewChildren =
      _Annotation._('ViewChildren', _MembersGroup.angularViewChildren);
  static const contentChild =
      _Annotation._('ContentChild', _MembersGroup.angularContentChildren);
  static const contentChildren =
      _Annotation._('ContentChildren', _MembersGroup.angularContentChildren);

  static const _annotations = [
    input,
    output,
    hostBinding,
    hostListener,
    viewChild,
    viewChildren,
    contentChild,
    contentChildren,
  ];

  const _Annotation._(this.name, this.group);

  static _Annotation? parse(String name) =>
      _annotations.firstWhereOrNull((annotation) => annotation.name == name);
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
  final _MemberNames memberNames;
  final _MembersGroup memberGroup;
  final _MembersGroup? previousMemberGroup;

  const _MemberOrder({
    required this.isWrong,
    required this.isAlphabeticallyWrong,
    required this.memberNames,
    required this.memberGroup,
    this.previousMemberGroup,
  });
}

class _MemberNames {
  final String currentName;
  final String? previousName;

  const _MemberNames({
    required this.currentName,
    this.previousName,
  });
}
