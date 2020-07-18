import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:dart_code_metrics/src/models/code_issue.dart';
import 'package:dart_code_metrics/src/models/code_issue_severity.dart';
import 'package:meta/meta.dart';

import 'base_rule.dart';
import 'rule_utils.dart';

// Inspired by TSLint (https://palantir.github.io/tslint/rules/member-ordering/)

class MemberOrderingRule extends BaseRule {
  static const _warningMessage = 'should be before';

  const MemberOrderingRule()
      : super(
          id: 'member-ordering',
          severity: CodeIssueSeverity.style,
        );

  @override
  Iterable<CodeIssue> check(
    CompilationUnit unit,
    Uri sourceUrl,
    String sourceContent,
  ) {
    final _visitor = _Visitor();

    unit.visitChildren(_visitor);

    return _visitor.membersInfo
        .where((info) => info.memberOrder.isWrong)
        .map(
          (info) => createIssue(
              this,
              '${info.memberOrder.membersGroup.name} $_warningMessage ${info.memberOrder.previousMemberGroup.name}',
              null,
              null,
              sourceUrl,
              sourceContent,
              unit.lineInfo,
              info.classMember),
        )
        .toList(growable: false);
  }
}

class _Visitor extends RecursiveAstVisitor<Object> {
  final _membersInfo = <_MemberInfo>[];

  Iterable<_MemberInfo> get membersInfo => _membersInfo;

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    super.visitClassDeclaration(node);

    for (final entry in node.childEntities) {
      if (entry is FieldDeclaration) {
        _visitFieldDeclaration(entry);
      } else if (entry is ConstructorDeclaration) {
        _visitConstructorDeclaration(entry);
      } else if (entry is MethodDeclaration) {
        _visitMethodDeclaration(entry);
      }
    }
  }

  void _visitFieldDeclaration(FieldDeclaration fieldDeclaration) {
    if (_hasMetadata(fieldDeclaration)) {
      return;
    }

    for (final variable in fieldDeclaration.fields.variables) {
      final membersGroup = _isPrivate(variable.name.name)
          ? _MembersGroup.privateFields
          : _MembersGroup.publicFields;

      _membersInfo.add(_MemberInfo(
        classMember: fieldDeclaration,
        memberOrder: _getOrder(membersGroup),
      ));
    }
  }

  void _visitMethodDeclaration(MethodDeclaration methodDeclaration) {
    if (_hasMetadata(methodDeclaration)) {
      return;
    }

    _MembersGroup membersGroup;

    if (methodDeclaration.isGetter) {
      membersGroup = _isPrivate(methodDeclaration.name.name)
          ? _MembersGroup.privateGetters
          : _MembersGroup.publicGetters;
    } else if (methodDeclaration.isSetter) {
      membersGroup = _isPrivate(methodDeclaration.name.name)
          ? _MembersGroup.privateSetters
          : _MembersGroup.publicSetters;
    } else {
      membersGroup = _isPrivate(methodDeclaration.name.name)
          ? _MembersGroup.privateMethods
          : _MembersGroup.publicMethods;
    }

    _membersInfo.add(_MemberInfo(
      classMember: methodDeclaration,
      memberOrder: _getOrder(membersGroup),
    ));
  }

  void _visitConstructorDeclaration(
      ConstructorDeclaration constructorDeclaration) {
    _membersInfo.add(_MemberInfo(
      classMember: constructorDeclaration,
      memberOrder: _getOrder(_MembersGroup.constructor),
    ));
  }

  bool _hasMetadata(ClassMember classMember) {
    for (final data in classMember.metadata) {
      final annotation = _Annotation.parse(data.name.name);

      if (annotation != null) {
        _membersInfo.add(_MemberInfo(
          classMember: classMember,
          memberOrder: _getOrder(annotation.group),
        ));

        return true;
      }
    }

    return false;
  }

  bool _isPrivate(String name) => name.startsWith('_');

  _MemberOrder _getOrder(_MembersGroup membersGroup) {
    if (_membersInfo.isNotEmpty) {
      final lastMemberInfo = _membersInfo.last;
      final lastGroupIndex = _MembersGroup.groupsOrder
          .indexOf(lastMemberInfo.memberOrder.membersGroup);
      final currentGroupIndex = _MembersGroup.groupsOrder.indexOf(membersGroup);

      return _MemberOrder(
        membersGroup: membersGroup,
        previousMemberGroup: lastMemberInfo.memberOrder.membersGroup,
        isWrong: (lastMemberInfo.memberOrder.membersGroup == membersGroup &&
                lastMemberInfo.memberOrder.isWrong) ||
            lastGroupIndex > currentGroupIndex,
      );
    }

    return _MemberOrder(isWrong: false, membersGroup: membersGroup);
  }
}

@immutable
class _MembersGroup {
  final String name;

  const _MembersGroup._(this.name);

  // Generic
  static const publicFields = _MembersGroup._('public_fields');
  static const privateFields = _MembersGroup._('private_field');
  static const publicGetters = _MembersGroup._('public_getters');
  static const privateGetters = _MembersGroup._('private_getters');
  static const publicSetters = _MembersGroup._('public_setters');
  static const privateSetters = _MembersGroup._('private_setters');
  static const publicMethods = _MembersGroup._('public_methods');
  static const privateMethods = _MembersGroup._('private_methods');
  static const constructor = _MembersGroup._('constructor');

  // Angular
  static const angularInputs = _MembersGroup._('angular_inputs');
  static const angularOutputs = _MembersGroup._('angular_outputs');
  static const angularHostBindings = _MembersGroup._('angular_host_bindings');
  static const angularHostListeners = _MembersGroup._('angular_host_listeners');

  static List<_MembersGroup> groupsOrder = [
    publicFields,
    privateFields,
    publicGetters,
    privateGetters,
    publicSetters,
    privateSetters,
    publicMethods,
    privateMethods,
    constructor,
    angularInputs,
    angularOutputs,
    angularHostBindings,
    angularHostListeners,
  ];

  static _MembersGroup parse(String name) =>
      groupsOrder.firstWhere((group) => group.name == name, orElse: () => null);
}

@immutable
class _Annotation {
  final String name;
  final _MembersGroup group;

  const _Annotation._(this.name, this.group);

  static const input = _Annotation._('Input', _MembersGroup.angularInputs);
  static const output = _Annotation._('Output', _MembersGroup.angularOutputs);
  static const hostBinding =
      _Annotation._('HostBinding', _MembersGroup.angularHostBindings);
  static const hostListener =
      _Annotation._('HostListener', _MembersGroup.angularHostListeners);

  static List<_Annotation> annotations = [
    input,
    output,
    hostBinding,
    hostListener,
  ];

  static _Annotation parse(String name) => annotations
      .firstWhere((annotation) => annotation.name == name, orElse: () => null);
}

@immutable
class _MemberInfo {
  final ClassMember classMember;
  final _MemberOrder memberOrder;

  const _MemberInfo({
    this.classMember,
    this.memberOrder,
  });
}

@immutable
class _MemberOrder {
  final bool isWrong;
  final _MembersGroup membersGroup;
  final _MembersGroup previousMemberGroup;

  const _MemberOrder({
    this.membersGroup,
    this.previousMemberGroup,
    this.isWrong,
  });
}
