part of 'prefer_correct_identifier_length.dart';

class _Visitor extends ScopeVisitor {
  final _identifiers = <VariableDeclaration>[];
  final _functionNames = <FunctionDeclaration>[];
  final _setters = <FunctionDeclaration>[];
  final _getters = <FunctionDeclaration>[];
  final _classNames = <ClassDeclaration>[];
  final _methods = <MethodDeclaration>[];
  final _constructors = <ConstructorDeclaration>[];
  final _parameters = <FormalParameter>[];

  Iterable<VariableDeclaration> get variablesNode => _identifiers;

  Iterable<FunctionDeclaration> get functionNode => _functionNames;

  Iterable<FunctionDeclaration> get getters => _getters;

  Iterable<FunctionDeclaration> get setters => _setters;

  Iterable<ClassDeclaration> get classNode => _classNames;

  Iterable<MethodDeclaration> get methodNode => _methods;

  Iterable<ConstructorDeclaration> get constructorNode => _constructors;

  Iterable<FormalParameter> get argumentNode => _parameters;

  @override
  void visitVariableDeclaration(VariableDeclaration node) {
    super.visitVariableDeclaration(node);

    _identifiers.add(node);
  }

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    super.visitMethodDeclaration(node);

    _methods.add(node);

    final parameters = node.parameters;

    if (node.externalKeyword != null ||
        (parameters == null || parameters.parameters.isEmpty)) {
      return;
    } else {
      _parameters.addAll(parameters.parameters.toList());
    }
  }

  @override
  void visitConstructorDeclaration(ConstructorDeclaration node) {
    super.visitConstructorDeclaration(node);

    _constructors.add(node);
  }

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    super.visitFunctionDeclaration(node);

    if (node.isGetter) {
      _getters.add(node);

      return;
    } else if (node.isSetter) {
      _setters.add(node);

      return;
    } else {
      _functionNames.add(node);
    }

    final parameters = node.functionExpression.parameters;

    if (node.externalKeyword != null ||
        (parameters == null || parameters.parameters.isEmpty)) {
      return;
    } else {
      _parameters.addAll(parameters.parameters.toList());
    }
  }

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    super.visitClassDeclaration(node);

    _classNames.add(node);
  }
}
