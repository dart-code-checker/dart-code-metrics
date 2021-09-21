import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';

class UnusedLocalizationVisitor extends RecursiveAstVisitor<void> {
  final RegExp classPattern;

  final _invocations = <ClassElement, Set<String>>{};

  Map<ClassElement, Set<String>> get invocations => _invocations;

  UnusedLocalizationVisitor(this.classPattern);

  @override
  void visitMethodInvocation(MethodInvocation node) {
    super.visitMethodInvocation(node);

    final target = node.target;

    if (target is SimpleIdentifier && target.name.endsWith('I18n')) {
      final staticElement = target.staticElement;
      final name = node.methodName.name;

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
  void visitPrefixedIdentifier(PrefixedIdentifier node) {
    super.visitPrefixedIdentifier(node);

    final prefix = node.prefix;

    if (classPattern.hasMatch(prefix.name)) {
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
}
