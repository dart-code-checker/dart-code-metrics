import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

import '../../models/issue.dart';
import '../../models/severity.dart';
import '../../utils/node_utils.dart';
import '../../utils/rule_utils.dart';
import 'obsolete_rule.dart';

class MemberOrderingExtendedRule extends ObsoleteRule {
  static const ruleId = 'member-ordering-extended';
  static const _documentationUrl = '';

  static const _warningMessage = 'should be before';
  static const _warningAlphabeticalMessage = 'should be alphabetically before';

  final List<_MemberGroup> _groupsOrder;
  final bool _alphabetize;

  MemberOrderingExtendedRule({Map<String, Object> config = const {}})
      : _groupsOrder = _parseOrder(config),
        _alphabetize = (config['alphabetize'] as bool?) ?? false,
        super(
          id: ruleId,
          documentationUrl: Uri.parse(_documentationUrl),
          severity: readSeverity(config, Severity.style),
        );

  @override
  Iterable<Issue> check(ResolvedUnitResult source) {
    final _visitor = _Visitor(_groupsOrder);

    final membersInfo = [
      for (final entry in source.unit!.childEntities)
        if (entry is ClassDeclaration) ...entry.accept(_visitor)!,
    ];

    return [
      ...membersInfo.where((info) => info.memberOrder.isWrong).map(
            (info) => createIssue(
              rule: this,
              location: nodeLocation(
                node: info.classMember,
                source: source,
                withCommentOrMetadata: true,
              ),
              message:
                  '${info.memberOrder.memberGroup} $_warningMessage ${info.memberOrder.previousMemberGroup}',
            ),
          ),
      if (_alphabetize)
        ...membersInfo
            .where((info) => info.memberOrder.isAlphabeticallyWrong)
            .map(
              (info) => createIssue(
                rule: this,
                location: nodeLocation(
                  node: info.classMember,
                  source: source,
                  withCommentOrMetadata: true,
                ),
                message:
                    '${info.memberOrder.memberNames.currentName} $_warningAlphabeticalMessage ${info.memberOrder.memberNames.previousName}',
              ),
            ),
    ];
  }

  static List<_MemberGroup> _parseOrder(Map<String, Object> config) {
    final order = config.containsKey('order') && config['order'] is Iterable
        ? List<String>.from(config['order'] as Iterable)
        : <String>[
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

    return order.map(parseGroup).whereNotNull().toList();
  }

  // ignore: long-method
  static _MemberGroup? parseGroup(String group) {
    final type = _MemberType.parse(group.split('_').lastOrNull);
    final regExp = RegExp(
      '(overridden_|protected_)?(private_|public_)?(static_)?(late_)?'
      '(var_|final_|const_)?(nullable_)?(named_)?(factory_)?',
    );
    final result = regExp.allMatches(group.toLowerCase());

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
            memberNames.currentName.compareTo(memberNames.previousName!) != 1,
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
          group.modifier == parsedGroup.modifier);

  bool _isMethodGroup(_MemberGroup group, _MemberGroup parsedGroup) =>
      group is _MethodMemberGroup &&
      parsedGroup is _MethodMemberGroup &&
      (!group.isStatic || group.isStatic == parsedGroup.isStatic) &&
      (!group.isNullable || group.isNullable == parsedGroup.isNullable) &&
      (group.modifier == _Modifier.unset ||
          group.modifier == parsedGroup.modifier);

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
          group.modifier == parsedGroup.modifier);

  bool _isFieldGroup(_MemberGroup group, _MemberGroup parsedGroup) =>
      group is _FieldMemberGroup &&
      parsedGroup is _FieldMemberGroup &&
      (!group.isLate || group.isLate == parsedGroup.isLate) &&
      (!group.isStatic || group.isStatic == parsedGroup.isStatic) &&
      (!group.isNullable || group.isNullable == parsedGroup.isNullable) &&
      (group.modifier == _Modifier.unset ||
          group.modifier == parsedGroup.modifier) &&
      (group.keyword == _FieldKeyword.unset ||
          group.keyword == parsedGroup.keyword);
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

@immutable
class _Annotation {
  final String name;

  static const override = _Annotation._('overridden');
  static const protected = _Annotation._('protected');
  static const unset = _Annotation._('unset');

  static const all = [
    override,
    protected,
    unset,
  ];

  const _Annotation._(this.name);

  static _Annotation parse(String? name) => all.firstWhere(
        (annotation) => annotation.name == name,
        orElse: () => _Annotation.unset,
      );
}

class _Modifier {
  final String type;

  const _Modifier(this.type);

  static const public = _Modifier('public');
  static const private = _Modifier('private');
  static const unset = _Modifier('unset');

  static const all = [
    public,
    private,
    unset,
  ];

  static _Modifier parse(String? name) => all
      .firstWhere((type) => type.type == name, orElse: () => _Modifier.unset);
}

class _MemberType {
  final String type;

  static const field = _MemberType._('fields');
  static const method = _MemberType._('methods');
  static const constructor = _MemberType._('constructors');
  static const getter = _MemberType._('getters');
  static const setter = _MemberType._('setters');
  static const getterAndSetter = _MemberType._('getters_setters');

  static const all = [
    field,
    method,
    constructor,
    getter,
    setter,
    getterAndSetter,
  ];

  const _MemberType._(this.type);

  static _MemberType? parse(String? name) =>
      all.firstWhereOrNull((type) => name == type.type);
}

class _FieldKeyword {
  final String type;

  static const isFinal = _FieldKeyword('final');
  static const isConst = _FieldKeyword('const');
  static const isVar = _FieldKeyword('var');
  static const unset = _FieldKeyword('unset');

  static const all = [
    isFinal,
    isConst,
    isVar,
    unset,
  ];

  const _FieldKeyword(this.type);

  static _FieldKeyword parse(String? name) => all.firstWhere(
        (type) => type.type == name,
        orElse: () => _FieldKeyword.unset,
      );
}

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
