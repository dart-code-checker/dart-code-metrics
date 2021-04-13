import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:collection/collection.dart';

import '../../models/issue.dart';
import '../../models/severity.dart';
import '../../utils/node_utils.dart';
import '../../utils/rule_utils.dart';
import 'obsolete_rule.dart';

class AlwaysRemoveListenerRule extends ObsoleteRule {
  static const String ruleId = 'always-remove-listener';
  static const _documentationUrl = '';

  static const _warningMessage =
      'Listener is not removed. This might lead to a memory leak.';

  AlwaysRemoveListenerRule({Map<String, Object> config = const {}})
      : super(
          id: ruleId,
          documentationUrl: Uri.parse(_documentationUrl),
          severity: readSeverity(config, Severity.warning),
        );

  @override
  Iterable<Issue> check(ResolvedUnitResult source) {
    final _visitor = _Visitor();

    source.unit?.visitChildren(_visitor);

    return _visitor.missingInvocations
        .map((invocation) => createIssue(
              rule: this,
              location: nodeLocation(
                node: invocation,
                source: source,
                withCommentOrMetadata: true,
              ),
              message: _warningMessage,
            ))
        .toList(growable: false);
  }
}

class _Visitor extends RecursiveAstVisitor<void> {
  final _missingInvocations = <MethodInvocation>[];

  Iterable<MethodInvocation> get missingInvocations => _missingInvocations;

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    super.visitMethodDeclaration(node);

    final parent = node.parent;
    final body = node.body;

    if (parent is! ClassDeclaration || body is! BlockFunctionBody) {
      return;
    }

    switch (node.name.name) {
      case 'initState':
        {
          final visitor = _ListenableVisitor();
          final dispose = _getDisposeMethodDeclaration(parent);

          node.visitChildren(visitor);
          dispose?.visitChildren(visitor);

          _compareInvocations(
            visitor.addedListeners,
            visitor.removedListeners,
          );

          return;
        }

      case 'didUpdateWidget':
        {
          final widgetParameter = node.parameters?.parameters.firstOrNull;
          if (widgetParameter != null) {
            final visitor = _ListenableVisitor();
            node.visitChildren(visitor);

            _compareDidUpdateInvocations(
              visitor.addedListeners,
              visitor.removedListeners,
              widgetParameter,
            );
          }

          return;
        }

      default:
        return;
    }
  }

  void _compareInvocations(
    Iterable<MethodInvocation> addedListeners,
    Iterable<MethodInvocation> removedListeners,
  ) {
    for (final addedListener in addedListeners) {
      final target = addedListener.realTarget;
      if (target is Identifier) {
        _compareInvocation(
          addedListener,
          removedListeners,
          target.name,
          target.staticElement,
        );
      }
    }
  }

  void _compareDidUpdateInvocations(
    Iterable<MethodInvocation> addedListeners,
    Iterable<MethodInvocation> removedListeners,
    FormalParameter widgetParameter,
  ) {
    for (final addedListener in addedListeners) {
      final target = addedListener.realTarget;
      final widgetType = widgetParameter.declaredElement?.type;

      if (target is PrefixedIdentifier &&
          _isRootWidget(target.prefix.staticType, widgetType)) {
        final targetName = widgetParameter.identifier != null
            ? [
                widgetParameter.identifier?.name,
                ...(target.name.split('.')..removeAt(0)),
              ].join('.')
            : null;

        _compareInvocation(
          addedListener,
          removedListeners,
          targetName,
          target.staticElement,
        );
      } else if (target is Identifier) {
        _compareInvocation(
          addedListener,
          removedListeners,
          target.name,
          target.staticElement,
        );
      }
    }
  }

  void _compareInvocation(
    MethodInvocation addedListener,
    Iterable<MethodInvocation> removedListeners,
    String? targetName,
    Element? staticElement,
  ) {
    final removedListener = removedListeners
        .where((invocation) =>
            _haveSameTargets(invocation, targetName, staticElement))
        .toList();

    final haveNotSameCallbacks = removedListener.firstWhereOrNull(
          (listener) => _haveSameCallbacks(addedListener, listener),
        ) ==
        null;

    if (removedListener.isEmpty || haveNotSameCallbacks) {
      _missingInvocations.add(addedListener);
    }
  }

  MethodDeclaration? _getDisposeMethodDeclaration(ClassDeclaration parent) =>
      parent.members.firstWhereOrNull((member) =>
              member is MethodDeclaration && member.name.name == 'dispose')
          as MethodDeclaration?;

  bool _haveSameTargets(
    MethodInvocation removedListener,
    String? targetName,
    Element? staticElement,
  ) {
    final removedTarget = removedListener.realTarget;

    return removedTarget is Identifier &&
        removedTarget.name == targetName &&
        removedTarget.staticElement == staticElement;
  }

  bool _haveSameCallbacks(
    MethodInvocation addedListener,
    MethodInvocation removedListener,
  ) {
    final addedCallback = addedListener.argumentList.arguments.firstOrNull;
    final removedCallback = removedListener.argumentList.arguments.firstOrNull;

    return addedCallback is Identifier &&
        removedCallback is Identifier &&
        addedCallback.name == removedCallback.name &&
        addedCallback.staticElement == removedCallback.staticElement;
  }

  bool _isRootWidget(DartType? type, DartType? rootType) =>
      type != null &&
      type.getDisplayString(withNullability: false) ==
          rootType?.getDisplayString(withNullability: false);
}

class _ListenableVisitor extends RecursiveAstVisitor<void> {
  final _addedListeners = <MethodInvocation>[];
  final _removedListeners = <MethodInvocation>[];

  Iterable<MethodInvocation> get addedListeners => _addedListeners;

  Iterable<MethodInvocation> get removedListeners => _removedListeners;

  @override
  void visitMethodInvocation(MethodInvocation node) {
    super.visitMethodInvocation(node);

    if (node.methodName.name == 'addListener') {
      final type = node.realTarget?.staticType;
      if (type is InterfaceType &&
          type.allSupertypes.firstWhereOrNull(_isListenable) != null) {
        _addedListeners.add(node);
      }
      // Think about dispose
    } else if (node.methodName.name == 'removeListener') {
      final type = node.realTarget?.staticType;
      if (type is InterfaceType &&
          type.allSupertypes.firstWhereOrNull(_isListenable) != null) {
        _removedListeners.add(node);
      }
    }
  }

  bool _isListenable(DartType type) =>
      type.getDisplayString(withNullability: false) == 'Listenable';
}
