part of 'prefer_correct_identifier_length.dart';

class _Visitor extends ScopeVisitor {
  final _variableDeclaration = <VariableDeclaration>[];
  final _functionDeclaration = <FunctionDeclaration>[];
  final _classDeclaration = <ClassDeclaration>[];

  Iterable<VariableDeclaration> get variablesNode => _variableDeclaration;

  Iterable<FunctionDeclaration> get functionNode => _functionDeclaration;

  Iterable<ClassDeclaration> get classNode => _classDeclaration;

  @override
  void visitVariableDeclaration(VariableDeclaration node) {
    super.visitVariableDeclaration(node);

    _variableDeclaration.add(node);
  }

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    super.visitFunctionDeclaration(node);

    _functionDeclaration.add(node);
  }

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    super.visitClassDeclaration(node);

    _classDeclaration.add(node);
  }
}
