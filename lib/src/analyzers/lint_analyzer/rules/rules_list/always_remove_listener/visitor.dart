part of 'always_remove_listener_rule.dart';

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

    switch (node.name.lexeme) {
      case 'initState':
        {
          final visitor = _ListenableVisitor();
          final dispose = _getDisposeMethodDeclaration(parent);

          node.visitChildren(visitor);
          dispose?.visitChildren(visitor);

          _compareInvocations(
            visitor.addedListeners,
            visitor.removedListeners,
            visitor.disposedListeners,
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
              visitor.disposedListeners,
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
    Iterable<MethodInvocation> disposedListeners,
  ) {
    for (final addedListener in addedListeners) {
      final target = addedListener.realTarget;
      if (target is Identifier) {
        _compareInvocation(
          addedListener,
          removedListeners,
          disposedListeners,
          target.name,
          target.staticElement,
        );
      }
    }
  }

  void _compareDidUpdateInvocations(
    Iterable<MethodInvocation> addedListeners,
    Iterable<MethodInvocation> removedListeners,
    Iterable<MethodInvocation> disposedListeners,
    FormalParameter widgetParameter,
  ) {
    for (final addedListener in addedListeners) {
      final target = addedListener.realTarget;
      final widgetType = widgetParameter.declaredElement?.type;

      if (target is PrefixedIdentifier &&
          _isRootWidget(target.prefix.staticType, widgetType)) {
        final name = widgetParameter.name?.lexeme;
        final targetName = name != null
            ? [
                name,
                ...(target.name.split('.')..removeAt(0)),
              ].join('.')
            : null;

        _compareInvocation(
          addedListener,
          removedListeners,
          disposedListeners,
          targetName,
          target.staticElement,
        );
      } else if (target is Identifier) {
        _compareInvocation(
          addedListener,
          removedListeners,
          disposedListeners,
          target.name,
          target.staticElement,
        );
      }
    }
  }

  void _compareInvocation(
    MethodInvocation addedListener,
    Iterable<MethodInvocation> removedListeners,
    Iterable<MethodInvocation> disposedListeners,
    String? targetName,
    Element? staticElement,
  ) {
    final removedListener = removedListeners
        .where((invocation) =>
            _haveSameTargets(invocation, targetName, staticElement))
        .toList();

    final haveNotSameCallbacks = !removedListener
        .any((listener) => _haveSameCallbacks(addedListener, listener));

    final disposedListener = disposedListeners
        .where((invocation) =>
            _haveSameTargets(invocation, targetName, staticElement))
        .toList();

    if ((removedListener.isEmpty || haveNotSameCallbacks) &&
        disposedListener.isEmpty) {
      _missingInvocations.add(addedListener);
    }
  }

  MethodDeclaration? _getDisposeMethodDeclaration(ClassDeclaration parent) =>
      parent.members.firstWhereOrNull((member) =>
              member is MethodDeclaration && member.name.lexeme == 'dispose')
          as MethodDeclaration?;

  bool _haveSameTargets(
    MethodInvocation removedListener,
    String? targetName,
    Element? staticElement,
  ) {
    final removedTarget = removedListener.realTarget;

    return removedTarget is Identifier &&
        removedTarget.name == targetName &&
        (removedTarget.staticElement == staticElement ||
            removedTarget.staticElement?.declaration ==
                staticElement?.declaration);
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
  final _disposedListeners = <MethodInvocation>[];

  Iterable<MethodInvocation> get addedListeners => _addedListeners;

  Iterable<MethodInvocation> get removedListeners => _removedListeners;

  Iterable<MethodInvocation> get disposedListeners => _disposedListeners;

  @override
  void visitMethodInvocation(MethodInvocation node) {
    super.visitMethodInvocation(node);

    final name = node.methodName.name;

    if (name == 'addListener') {
      final type = node.realTarget?.staticType;
      if (isSubclassOfListenable(type)) {
        _addedListeners.add(node);
      }
    } else if (name == 'removeListener') {
      final type = node.realTarget?.staticType;
      if (isSubclassOfListenable(type)) {
        _removedListeners.add(node);
      }
    } else if (name == 'dispose') {
      final type = node.realTarget?.staticType;
      if (isSubclassOfListenable(type)) {
        _disposedListeners.add(node);
      }
    }
  }
}
