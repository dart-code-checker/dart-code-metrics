part of 'avoid_returning_widgets_rule.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final _invocations = <InvocationExpression>[];
  final _getters = <Declaration>[];
  final _globalFunctions = <Declaration>[];

  final Iterable<String> _ignoredNames;
  final Iterable<String> _ignoredAnnotations;

  Iterable<InvocationExpression> get invocations => _invocations;
  Iterable<Declaration> get getters => _getters;
  Iterable<Declaration> get globalFunctions => _globalFunctions;

  _Visitor(this._ignoredNames, this._ignoredAnnotations);

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    if (node.parent is! CompilationUnit) {
      return;
    }

    final declaration = _visitDeclaration(
      node,
      node.name,
      node.returnType,
      _ignoredNames,
      _ignoredAnnotations,
      isSetter: node.isSetter,
    );

    if (declaration != null) {
      _globalFunctions.add(declaration);
    }
  }

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    final classType = node.extendsClause?.superclass2.type;
    if (!isWidgetOrSubclass(classType) && !isWidgetStateOrSubclass(classType)) {
      return;
    }

    final declarationsVisitor = _DeclarationsVisitor(
      _ignoredNames,
      _ignoredAnnotations,
    );
    node.visitChildren(declarationsVisitor);

    final names = declarationsVisitor.declarations
        .map((declaration) => declaration.declaredElement?.name)
        .whereType<String>()
        .toSet();

    final invocationsVisitor = _InvocationsVisitor(names);
    node.visitChildren(invocationsVisitor);

    _invocations.addAll(invocationsVisitor.invocations);
    _getters.addAll(declarationsVisitor.getters);
  }
}

class _InvocationsVisitor extends RecursiveAstVisitor<void> {
  final _invocations = <InvocationExpression>[];

  final Set<String> _declarationNames;

  Iterable<InvocationExpression> get invocations => _invocations;

  _InvocationsVisitor(this._declarationNames);

  @override
  void visitMethodInvocation(MethodInvocation node) {
    if (_declarationNames.contains(node.methodName.name) &&
        node.realTarget == null) {
      _invocations.add(node);
    }
  }
}

class _DeclarationsVisitor extends RecursiveAstVisitor<void> {
  final _declarations = <Declaration>[];
  final _getters = <Declaration>[];

  final Iterable<String> _ignoredNames;
  final Iterable<String> _ignoredAnnotations;

  Iterable<Declaration> get declarations => _declarations;
  Iterable<Declaration> get getters => _getters;

  _DeclarationsVisitor(this._ignoredNames, this._ignoredAnnotations);

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    super.visitMethodDeclaration(node);

    final declaration = _visitDeclaration(
      node,
      node.name,
      node.returnType,
      _ignoredNames,
      _ignoredAnnotations,
      isSetter: node.isSetter,
    );

    if (declaration != null) {
      if (node.isGetter) {
        _getters.add(declaration);
      } else {
        _declarations.add(declaration);
      }
    }
  }

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    super.visitFunctionDeclaration(node);

    final declaration = _visitDeclaration(
      node,
      node.name,
      node.returnType,
      _ignoredNames,
      _ignoredAnnotations,
      isSetter: node.isSetter,
    );

    if (declaration != null) {
      _declarations.add(declaration);
    }
  }
}
