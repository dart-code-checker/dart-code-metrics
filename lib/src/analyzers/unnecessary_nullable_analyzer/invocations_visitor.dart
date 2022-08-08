// ignore_for_file: public_member_api_docs, deprecated_member_use

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';

import 'models/invocations_usage.dart';

class InvocationsVisitor extends RecursiveAstVisitor<void> {
  final invocationsUsages = InvocationsUsage();

  @override
  void visitExportDirective(ExportDirective node) {
    super.visitExportDirective(node);

    final path = node.uriSource?.fullName;
    if (path != null) {
      invocationsUsages.exports.add(path);
    }
  }

  @override
  void visitMethodInvocation(MethodInvocation node) {
    super.visitMethodInvocation(node);

    _recordUsedElement(node.methodName.staticElement, node.argumentList);
  }

  @override
  void visitFunctionExpressionInvocation(FunctionExpressionInvocation node) {
    super.visitFunctionExpressionInvocation(node);

    _recordUsedElement(node.staticElement, node.argumentList);
  }

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    super.visitInstanceCreationExpression(node);

    _recordUsedElement(node.constructorName.staticElement, node.argumentList);
  }

  /// Records use of a not prefixed [element].
  void _recordUsedElement(Element? element, ArgumentList arguments) {
    if (element == null) {
      return;
    }
    // Ignore if an unknown library.
    final containingLibrary = element.library;
    if (containingLibrary == null) {
      return;
    }
    // Remember the element.
    invocationsUsages.addElementUsage(element, {arguments});
  }
}
