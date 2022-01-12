// ignore_for_file: public_member_api_docs

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';

class UnusedL10nVisitor extends RecursiveAstVisitor<void> {
  final RegExp _classPattern;

  final _invocations = <ClassElement, Set<String>>{};

  Map<ClassElement, Set<String>> get invocations => _invocations;

  UnusedL10nVisitor(this._classPattern);

  @override
  void visitMethodInvocation(MethodInvocation node) {
    super.visitMethodInvocation(node);

    final target = node.target;
    final name = node.methodName.name;

    if (_matchIdentifier(target)) {
      _addMemberInvocation(target as SimpleIdentifier, name);
    } else if (_matchConstructorOf(target)) {
      _addMemberInvocationOnConstructor(
        target as InstanceCreationExpression,
        name,
      );
    } else if (_matchExtension(target)) {
      final classTarget = (target as PrefixedIdentifier).identifier;

      _addMemberInvocationOnAccessor(classTarget, name);
    } else if (_matchMethodOf(target)) {
      final classTarget = (target as MethodInvocation).target;

      if (_matchIdentifier(classTarget)) {
        _addMemberInvocation(classTarget as SimpleIdentifier, name);
      }
    } else if (_matchStaticGetter(target)) {
      _addMemberInvocation((target as PrefixedIdentifier).prefix, name);
    }
  }

  @override
  void visitPrefixedIdentifier(PrefixedIdentifier node) {
    super.visitPrefixedIdentifier(node);

    final prefix = node.prefix;

    if (_classPattern.hasMatch(prefix.name)) {
      final staticElement = prefix.staticElement;
      final name = node.identifier.name;

      if (staticElement is ClassElement) {
        _invocations.update(
          staticElement,
          (value) => value..add(name),
          ifAbsent: () => {name},
        );
      }
    }
  }

  @override
  void visitPropertyAccess(PropertyAccess node) {
    super.visitPropertyAccess(node);

    final target = node.target;
    final name = node.propertyName.name;

    if (_matchConstructorOf(target)) {
      _addMemberInvocationOnConstructor(
        target as InstanceCreationExpression,
        name,
      );
    } else if (_matchExtension(target)) {
      final classTarget = (target as PrefixedIdentifier).identifier;

      _addMemberInvocationOnAccessor(classTarget, name);
    } else if (_matchMethodOf(target)) {
      final classTarget = (target as MethodInvocation).target;

      if (_matchIdentifier(classTarget)) {
        _addMemberInvocation(classTarget as SimpleIdentifier, name);
      }
    } else if (_matchStaticGetter(target)) {
      _addMemberInvocation((target as PrefixedIdentifier).prefix, name);
    }
  }

  bool _matchIdentifier(Expression? target) =>
      target is SimpleIdentifier && _classPattern.hasMatch(target.name);

  bool _matchConstructorOf(Expression? target) =>
      target is InstanceCreationExpression &&
      _classPattern.hasMatch(
        target.staticType?.getDisplayString(withNullability: false) ?? '',
      ) &&
      target.constructorName.name?.name == 'of';

  bool _matchMethodOf(Expression? target) =>
      target is MethodInvocation && target.methodName.name == 'of';

  bool _matchExtension(Expression? target) =>
      target is PrefixedIdentifier &&
      target.staticElement?.enclosingElement is ExtensionElement;

  bool _matchStaticGetter(Expression? target) =>
      target is PrefixedIdentifier &&
      _classPattern.hasMatch(
        target.staticType?.getDisplayString(withNullability: false) ?? '',
      );

  void _addMemberInvocation(SimpleIdentifier target, String name) {
    final staticElement = target.staticElement;

    if (staticElement is ClassElement) {
      _invocations.update(
        staticElement,
        (value) => value..add(name),
        ifAbsent: () => {name},
      );
    }
  }

  void _addMemberInvocationOnConstructor(
    InstanceCreationExpression target,
    String name,
  ) {
    final staticElement =
        target.constructorName.staticElement?.enclosingElement;

    if (staticElement is ClassElement) {
      _invocations.update(
        staticElement,
        (value) => value..add(name),
        ifAbsent: () => {name},
      );
    }
  }

  void _addMemberInvocationOnAccessor(SimpleIdentifier target, String name) {
    final staticElement =
        target.staticElement?.enclosingElement as ExtensionElement;

    for (final element in staticElement.accessors) {
      if (_classPattern.hasMatch(element.returnType.toString())) {
        final classElement = element.returnType.element;

        if (classElement is ClassElement) {
          _invocations.update(
            classElement,
            (value) => value..add(name),
            ifAbsent: () => {name},
          );
          break;
        }
      }
    }
  }
}
