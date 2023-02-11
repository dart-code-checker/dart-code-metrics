// ignore_for_file: avoid_positional_boolean_parameters

part of 'avoid_returning_widgets_rule.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final _invocations = <InvocationExpression>[];
  final _getters = <Declaration>[];
  final _globalFunctions = <Declaration>[];

  final Iterable<String> _ignoredNames;
  final Iterable<String> _ignoredAnnotations;
  final bool _allowNullable;

  Iterable<InvocationExpression> get invocations => _invocations;
  Iterable<Declaration> get getters => _getters;
  Iterable<Declaration> get globalFunctions => _globalFunctions;

  _Visitor(this._ignoredNames, this._ignoredAnnotations, this._allowNullable);

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    if (node.parent is! CompilationUnit) {
      return;
    }

    final declaration = _visitDeclaration(
      node,
      node.name.lexeme,
      node.returnType,
      _ignoredNames,
      _ignoredAnnotations,
      isSetter: node.isSetter,
      allowNullable: _allowNullable,
    );

    if (declaration != null) {
      _globalFunctions.add(declaration);
    }
  }

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    final classType = node.extendsClause?.superclass.type;
    if (!isWidgetOrSubclass(classType) && !isWidgetStateOrSubclass(classType)) {
      return;
    }

    final declarationsVisitor = _DeclarationsVisitor(
      _ignoredNames,
      _ignoredAnnotations,
      _allowNullable,
    );
    node.visitChildren(declarationsVisitor);

    final names = declarationsVisitor.declarations
        .map((declaration) => declaration.declaredElement?.name)
        .whereType<String>()
        .toSet();

    final invocationsVisitor = _InvocationsVisitor(names, _allowNullable);
    node.visitChildren(invocationsVisitor);

    _invocations.addAll(invocationsVisitor.invocations);
    _getters.addAll(declarationsVisitor.getters);
  }
}

class _InvocationsVisitor extends RecursiveAstVisitor<void> {
  final _invocations = <InvocationExpression>[];

  final Set<String> _declarationNames;
  final bool _allowNullable;

  Iterable<InvocationExpression> get invocations => _invocations;

  _InvocationsVisitor(this._declarationNames, this._allowNullable);

  @override
  void visitMethodInvocation(MethodInvocation node) {
    if (_declarationNames.contains(node.methodName.name) &&
        node.realTarget == null &&
        !_isInsideBuilder(node)) {
      _invocations.add(node);
    }
  }

  bool _isInsideBuilder(MethodInvocation node) {
    final grandParent = node.parent?.parent;
    if (grandParent is FunctionExpression &&
        grandParent.parent is! NamedExpression) {
      return grandParent.staticParameterElement?.declaration.name == 'builder';
    }

    final expression = node.thisOrAncestorOfType<NamedExpression>();
    if (expression is NamedExpression) {
      final type = expression.staticType;
      if (type is FunctionType) {
        return type.returnType is InterfaceType &&
            _hasWidgetType(type.returnType, _allowNullable);
      }
    }

    return false;
  }
}

class _DeclarationsVisitor extends RecursiveAstVisitor<void> {
  final _declarations = <Declaration>[];
  final _getters = <Declaration>[];

  final Iterable<String> _ignoredNames;
  final Iterable<String> _ignoredAnnotations;
  final bool _allowNullable;

  Iterable<Declaration> get declarations => _declarations;
  Iterable<Declaration> get getters => _getters;

  _DeclarationsVisitor(
    this._ignoredNames,
    this._ignoredAnnotations,
    this._allowNullable,
  );

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    super.visitMethodDeclaration(node);

    final declaration = _visitDeclaration(
      node,
      node.name.lexeme,
      node.returnType,
      _ignoredNames,
      _ignoredAnnotations,
      isSetter: node.isSetter,
      allowNullable: _allowNullable,
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
      node.name.lexeme,
      node.returnType,
      _ignoredNames,
      _ignoredAnnotations,
      isSetter: node.isSetter,
      allowNullable: _allowNullable,
    );

    if (declaration != null) {
      _declarations.add(declaration);
    }
  }
}
