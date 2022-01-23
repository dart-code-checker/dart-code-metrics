// ignore_for_file: public_member_api_docs

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';

import 'models/file_elements_usage.dart';
import 'models/prefix_element_usage.dart';

// Copied from https://github.com/dart-lang/sdk/blob/main/pkg/analyzer/lib/src/error/imports_verifier.dart#L15

class UsedCodeVisitor extends RecursiveAstVisitor<void> {
  final FileElementsUsage fileElementsUsage = FileElementsUsage();

  @override
  void visitExportDirective(ExportDirective node) {
    super.visitExportDirective(node);

    final path = node.uriSource?.fullName;
    if (path != null) {
      fileElementsUsage.exports.add(path);
    }
  }

  @override
  void visitAssignmentExpression(AssignmentExpression node) {
    _recordAssignmentTarget(node, node.leftHandSide);

    super.visitAssignmentExpression(node);
  }

  @override
  void visitBinaryExpression(BinaryExpression node) {
    _recordIfExtensionMember(node.staticElement);

    super.visitBinaryExpression(node);
  }

  @override
  void visitFunctionExpressionInvocation(FunctionExpressionInvocation node) {
    _recordIfExtensionMember(node.staticElement);

    super.visitFunctionExpressionInvocation(node);
  }

  @override
  void visitIndexExpression(IndexExpression node) {
    _recordIfExtensionMember(node.staticElement);

    super.visitIndexExpression(node);
  }

  @override
  void visitPostfixExpression(PostfixExpression node) {
    _recordAssignmentTarget(node, node.operand);

    super.visitPostfixExpression(node);
  }

  @override
  void visitPrefixExpression(PrefixExpression node) {
    _recordAssignmentTarget(node, node.operand);
    _recordIfExtensionMember(node.staticElement);

    super.visitPrefixExpression(node);
  }

  @override
  void visitSimpleIdentifier(SimpleIdentifier node) {
    _visitIdentifier(node, node.staticElement);
  }

  void _recordAssignmentTarget(
    CompoundAssignmentExpression node,
    Expression target,
  ) {
    if (target is PrefixedIdentifier) {
      _visitIdentifier(target.identifier, node.readElement);
      _visitIdentifier(target.identifier, node.writeElement);
    } else if (target is PropertyAccess) {
      _visitIdentifier(target.propertyName, node.readElement);
      _visitIdentifier(target.propertyName, node.writeElement);
    } else if (target is SimpleIdentifier) {
      _visitIdentifier(target, node.readElement);
      _visitIdentifier(target, node.writeElement);
    }
  }

  void _recordIfExtensionMember(Element? element) {
    if (element != null) {
      final enclosingElement = element.enclosingElement;
      if (enclosingElement is ExtensionElement) {
        _recordUsedExtension(enclosingElement);
      }
    }
  }

  /// If the given [identifier] is prefixed with a [PrefixElement], fill the
  /// corresponding `UsedImportedElements.prefixMap` entry and return `true`.
  bool _recordPrefixMap(SimpleIdentifier identifier, Element element) {
    bool recordIfTargetIsPrefixElement(Expression? target) {
      if (target is SimpleIdentifier) {
        final targetElement = target.staticElement;
        if (targetElement is PrefixElement) {
          (fileElementsUsage.prefixMap.putIfAbsent(
            targetElement,
            () => PrefixElementUsage(_getPrefixUsagePaths(target), {}),
          )).add(element);

          return true;
        }
      }

      return false;
    }

    final parent = identifier.parent;

    if (parent is MethodInvocation && parent.methodName == identifier) {
      return recordIfTargetIsPrefixElement(parent.target);
    }

    if (parent is PrefixedIdentifier && parent.identifier == identifier) {
      return recordIfTargetIsPrefixElement(parent.prefix);
    }

    return false;
  }

  /// Records use of a not prefixed [element].
  void _recordUsedElement(Element element) {
    // // Ignore if an unknown library.
    final containingLibrary = element.library;
    if (containingLibrary == null) {
      return;
    }
    // Remember the element.
    fileElementsUsage.elements.add(element);
  }

  void _recordUsedExtension(ExtensionElement extension) {
    // Remember the element.
    fileElementsUsage.usedExtensions.add(extension);
  }

  void _visitIdentifier(SimpleIdentifier identifier, Element? element) {
    if (element == null) {
      return;
    }

    // Declarations are not a sign of usage.
    if (identifier.parent is Declaration) {
      return;
    }

    // Record `importPrefix.identifier` into 'prefixMap'.
    if (_recordPrefixMap(identifier, element)) {
      return;
    }

    final enclosingElement = element.enclosingElement;
    if (enclosingElement is CompilationUnitElement) {
      _recordUsedElement(element);
    } else if (enclosingElement is ExtensionElement) {
      _recordUsedExtension(enclosingElement);

      return;
    } else if (element is PrefixElement) {
      fileElementsUsage.prefixMap.putIfAbsent(
        element,
        () => PrefixElementUsage(_getPrefixUsagePaths(identifier), {}),
      );
    } else if (element is MultiplyDefinedElement) {
      // If the element is multiply defined then call this method recursively
      // for each of the conflicting elements.
      final conflictingElements = element.conflictingElements;
      final length = conflictingElements.length;
      for (var i = 0; i < length; i++) {
        final elt = conflictingElements[i];
        _visitIdentifier(identifier, elt);
      }
    }
  }

  Iterable<String> _getPrefixUsagePaths(SimpleIdentifier target) {
    final root = target.root;

    if (root is! CompilationUnit) {
      return [];
    }

    return root.directives.fold<List<String>>([], (previousValue, directive) {
      if (directive is ImportDirective &&
          directive.prefix?.name == target.name) {
        previousValue.add(directive.uriSource.toString());

        for (final config in directive.configurations) {
          previousValue.add(config.uriSource.toString());
        }
      }

      return previousValue;
    });
  }
}
