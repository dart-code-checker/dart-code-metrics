part of 'avoid_unnecessary_setstate_rule.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  static const _checkedMethods = [
    'initState',
    'didUpdateWidget',
    'didChangeDependencies',
    'build',
  ];

  final _setStateInvocations = <MethodInvocation>[];
  final _classMethodsInvocations = <MethodInvocation>[];

  Iterable<MethodInvocation> get setStateInvocations => _setStateInvocations;
  Iterable<MethodInvocation> get classMethodsInvocations =>
      _classMethodsInvocations;

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    super.visitClassDeclaration(node);

    final type = node.extendsClause?.superclass.type;
    if (type == null || !isWidgetStateOrSubclass(type)) {
      return;
    }

    final declarations = node.members.whereType<MethodDeclaration>().toList();
    final classMethodsNames =
        declarations.map((declaration) => declaration.name.lexeme).toSet();
    final bodies = declarations.map((declaration) => declaration.body).toList();
    final methods = declarations
        .where((member) => _checkedMethods.contains(member.name.lexeme))
        .toList();
    final restMethods = declarations
        .where((member) => !_checkedMethods.contains(member.name.lexeme))
        .toList();

    final visitedRestMethods = <String, bool>{};

    for (final method in methods) {
      final visitor = _MethodVisitor(classMethodsNames, bodies);
      method.visitChildren(visitor);

      _setStateInvocations.addAll(visitor.setStateInvocations);
      _classMethodsInvocations.addAll(
        visitor.classMethodsInvocations
            .where((invocation) => _containsSetState(
                  visitedRestMethods,
                  classMethodsNames,
                  bodies,
                  restMethods.firstWhere((method) =>
                      method.name.lexeme == invocation.methodName.name),
                ))
            .toList(),
      );
    }
  }

  bool _containsSetState(
    Map<String, bool> visitedRestMethods,
    Set<String> classMethodsNames,
    Iterable<FunctionBody> bodies,
    MethodDeclaration declaration,
  ) {
    final type = declaration.returnType?.type;
    if (type != null && (type.isDartAsyncFuture || type.isDartAsyncFutureOr)) {
      return false;
    }

    final name = declaration.name.lexeme;
    if (visitedRestMethods.containsKey(name) && visitedRestMethods[name]!) {
      return true;
    }

    final visitor = _MethodVisitor(classMethodsNames, bodies);
    declaration.visitChildren(visitor);

    final hasSetState = visitor.setStateInvocations.isNotEmpty;

    visitedRestMethods[name] = hasSetState;

    return hasSetState;
  }
}

class _MethodVisitor extends RecursiveAstVisitor<void> {
  final Set<String> classMethodsNames;
  final Iterable<FunctionBody> bodies;

  final _setStateInvocations = <MethodInvocation>[];
  final _classMethodsInvocations = <MethodInvocation>[];

  Iterable<MethodInvocation> get setStateInvocations => _setStateInvocations;
  Iterable<MethodInvocation> get classMethodsInvocations =>
      _classMethodsInvocations;

  _MethodVisitor(this.classMethodsNames, this.bodies);

  @override
  void visitMethodInvocation(MethodInvocation node) {
    super.visitMethodInvocation(node);

    final name = node.methodName.name;
    final notInBody = _isNotInFunctionBody(node);

    if (name == 'setState' && notInBody) {
      _setStateInvocations.add(node);
    } else if (classMethodsNames.contains(name) &&
        notInBody &&
        node.realTarget == null) {
      _classMethodsInvocations.add(node);
    }
  }

  bool _isNotInFunctionBody(MethodInvocation node) =>
      node.thisOrAncestorMatching(
        (parent) => parent is FunctionBody && !bodies.contains(parent),
      ) ==
      null;
}
