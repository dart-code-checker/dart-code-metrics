// ignore_for_file: public_member_api_docs

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:collection/collection.dart';

import '../../utils/flutter_types_utils.dart';
import 'models/file_elements_usage.dart';
import 'models/prefix_element_usage.dart';

// Copied from https://github.com/dart-lang/sdk/blob/main/pkg/analyzer/lib/src/error/imports_verifier.dart#L15

class UsedCodeVisitor extends RecursiveAstVisitor<void> {
  final fileElementsUsage = FileElementsUsage();

  UsedCodeVisitor();

  @override
  void visitImportDirective(ImportDirective node) {
    if (node.configurations.isNotEmpty) {
      final paths = node.configurations.map((config) {
        final uri = config.resolvedUri;

        return (uri is DirectiveUriWithSource) ? uri.source.fullName : null;
      }).whereNotNull();
      // ignore: deprecated_member_use
      final mainImport = node.element2?.importedLibrary?.source.fullName;

      final allPaths = {if (mainImport != null) mainImport, ...paths};

      fileElementsUsage.conditionalElements.update(
        allPaths,
        (conditionalElements) => conditionalElements,
        ifAbsent: () => {},
      );
    }

    super.visitImportDirective(node);
  }

  @override
  void visitExportDirective(ExportDirective node) {
    super.visitExportDirective(node);

    // ignore: deprecated_member_use
    final path = node.element2?.exportedLibrary?.source.fullName;
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
      // ignore: deprecated_member_use
      final enclosingElement = element.enclosingElement3;
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

  bool _recordConditionalElement(Element element) {
    // ignore: deprecated_member_use
    final elementPath = element.enclosingElement3?.source?.fullName;
    if (elementPath == null) {
      return false;
    }

    final entries = fileElementsUsage.conditionalElements.entries;
    for (final conditionalElement in entries) {
      if (conditionalElement.key.contains(elementPath)) {
        conditionalElement.value.add(element);

        return true;
      }
    }

    return false;
  }

  /// Records use of a not prefixed [element].
  void _recordUsedElement(Element element) {
    // Ignore if an unknown library.
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
    if (identifier.parent is Declaration &&
        !_isVariableDeclarationInitializer(identifier.parent, identifier)) {
      return;
    }

    // Usage in State<WidgetClassName> is not a sign of usage.
    if (_isUsedAsNamedTypeForWidgetState(identifier)) {
      return;
    }

    // Record elements that are imported with conditional imports
    if (_recordConditionalElement(element)) {
      return;
    }

    // Record `importPrefix.identifier` into 'prefixMap'.
    if (_recordPrefixMap(identifier, element)) {
      return;
    }

    // ignore: deprecated_member_use
    final enclosingElement = element.enclosingElement3;
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
      for (var index = 0; index < length; index++) {
        final elt = conflictingElements[index];
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
        // ignore: deprecated_member_use
        final path = directive.element2?.importedLibrary?.source.fullName;
        if (path != null) {
          previousValue.add(path);
        }

        for (final config in directive.configurations) {
          final uri = config.resolvedUri;
          if (uri is DirectiveUriWithSource) {
            previousValue.add(uri.source.fullName);
          }
        }
      }

      return previousValue;
    });
  }

  bool _isVariableDeclarationInitializer(
    AstNode? target,
    SimpleIdentifier identifier,
  ) =>
      target is VariableDeclaration && target.initializer == identifier;

  bool _isUsedAsNamedTypeForWidgetState(SimpleIdentifier identifier) {
    final grandGrandParent = identifier.parent?.parent?.parent;

    return grandGrandParent is NamedType &&
        isWidgetStateOrSubclass(grandGrandParent.type);
  }
}
