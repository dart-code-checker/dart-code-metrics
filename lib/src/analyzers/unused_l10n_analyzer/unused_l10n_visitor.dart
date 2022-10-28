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
    final name = node.identifier.name;

    if (_matchIdentifier(prefix)) {
      _addMemberInvocation(prefix, name);
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
      final prefix = target as PrefixedIdentifier;
      final classTarget = prefix.identifier;

      if (_matchIdentifier(classTarget)) {
        _addMemberInvocation(classTarget, name);
      }

      _addMemberInvocation(prefix.prefix, name);
    }
  }

  bool _matchIdentifier(Expression? target) =>
      target is SimpleIdentifier &&
      (_classPattern.hasMatch(target.name) ||
          _classPattern.hasMatch(
            target.staticType?.getDisplayString(withNullability: false) ?? '',
          ));

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
      // ignore: deprecated_member_use
      target.staticElement?.enclosingElement3 is ExtensionElement;

  bool _matchStaticGetter(Expression? target) =>
      target is PrefixedIdentifier &&
      _classPattern.hasMatch(
        target.staticType?.getDisplayString(withNullability: false) ?? '',
      );

  void _addMemberInvocation(SimpleIdentifier target, String name) {
    final staticElement = target.staticElement;

    if (staticElement is VariableElement) {
      // ignore: deprecated_member_use
      final classElement = staticElement.type.element2;
      if (_classPattern.hasMatch(classElement?.name ?? '')) {
        _tryAddInvocation(classElement, name);
      }

      return;
    } else if (staticElement is PropertyAccessorElement) {
      // ignore: deprecated_member_use
      final classElement = staticElement.type.returnType.element2;
      if (_classPattern.hasMatch(classElement?.name ?? '')) {
        _tryAddInvocation(classElement, name);
      }

      return;
    }

    _tryAddInvocation(staticElement, name);
  }

  void _addMemberInvocationOnConstructor(
    InstanceCreationExpression target,
    String name,
  ) {
    final staticElement =
        // ignore: deprecated_member_use
        target.constructorName.staticElement?.enclosingElement3;

    _tryAddInvocation(staticElement, name);
  }

  void _addMemberInvocationOnAccessor(SimpleIdentifier target, String name) {
    final staticElement =
        // ignore: deprecated_member_use
        target.staticElement?.enclosingElement3 as ExtensionElement;

    for (final element in staticElement.accessors) {
      if (_classPattern.hasMatch(element.returnType.toString())) {
        // ignore: deprecated_member_use
        final declaredElement = element.returnType.element2;

        _tryAddInvocation(declaredElement, name);
        break;
      }
    }
  }

  void _tryAddInvocation(Element? element, String name) {
    if (element is ClassElement) {
      _invocations.update(
        element,
        (value) => value..add(name),
        ifAbsent: () => {name},
      );
    }
  }
}
