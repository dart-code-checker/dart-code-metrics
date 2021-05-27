part of 'avoid_unnecessary_setstate.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  static const _checkedMethods = ['initState', 'didUpdateWidget', 'build'];

  final _setStateInvocations = <MethodInvocation>[];
  final _classMethodsInvocations = <MethodInvocation>[];

  Iterable<MethodInvocation> get setStateInvocations => _setStateInvocations;
  Iterable<MethodInvocation> get classMethodsInvocations =>
      _classMethodsInvocations;

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    super.visitClassDeclaration(node);

    final type = node.extendsClause?.superclass.type;
    if (type == null || !_hasWidgetStateType(type)) {
      return;
    }

    final methods = node.members
        .whereType<MethodDeclaration>()
        .where((member) => _checkedMethods.contains(member.name.name))
        .toList();
    final restMethods = node.members
        .whereType<MethodDeclaration>()
        .where((member) => !_checkedMethods.contains(member.name.name))
        .toList();
    final restMethodsNames =
        restMethods.map((method) => method.name.name).toList();

    final visitedRestMethods = <String, bool>{};

    for (final method in methods) {
      final visitor = _MethodVisitor(restMethodsNames);
      method.visitChildren(visitor);

      _setStateInvocations.addAll(visitor.setStateInvocations);
      _classMethodsInvocations.addAll(
        visitor.classMethodsInvocations
            .where((invocation) => _containsSetState(
                  visitedRestMethods,
                  restMethods.firstWhere((method) =>
                      method.name.name == invocation.methodName.name),
                ))
            .toList(),
      );
    }
  }

  bool _hasWidgetStateType(DartType type) =>
      _isWidgetState(type) || _isSubclassOfWidgetState(type);

  bool _isSubclassOfWidgetState(DartType? type) =>
      type is InterfaceType &&
      type.allSupertypes.firstWhereOrNull(_isWidgetState) != null;

  bool _isWidgetState(DartType? type) => type?.element?.displayName == 'State';

  bool _containsSetState(
    Map<String, bool> visitedRestMethods,
    MethodDeclaration declaration,
  ) {
    final type = declaration.returnType?.type;
    if (type != null && (type.isDartAsyncFuture || type.isDartAsyncFutureOr)) {
      return false;
    }

    final name = declaration.name.name;
    if (visitedRestMethods.containsKey(name) && visitedRestMethods[name]!) {
      return true;
    }

    final visitor = _MethodVisitor([]);
    declaration.visitChildren(visitor);

    final hasSetState = visitor.setStateInvocations.isNotEmpty;

    visitedRestMethods[name] = hasSetState;

    return hasSetState;
  }
}

class _MethodVisitor extends RecursiveAstVisitor<void> {
  final Iterable<String> classMethodsNames;

  final _setStateInvocations = <MethodInvocation>[];
  final _classMethodsInvocations = <MethodInvocation>[];

  Iterable<MethodInvocation> get setStateInvocations => _setStateInvocations;
  Iterable<MethodInvocation> get classMethodsInvocations =>
      _classMethodsInvocations;

  _MethodVisitor(this.classMethodsNames);

  @override
  void visitMethodInvocation(MethodInvocation node) {
    super.visitMethodInvocation(node);

    final name = node.methodName.name;

    if (name == 'setState' &&
        node.thisOrAncestorOfType<ArgumentList>() == null) {
      _setStateInvocations.add(node);
    } else if (classMethodsNames.contains(name) &&
        node.thisOrAncestorOfType<ArgumentList>() == null &&
        node.realTarget == null) {
      _classMethodsInvocations.add(node);
    }
  }
}
