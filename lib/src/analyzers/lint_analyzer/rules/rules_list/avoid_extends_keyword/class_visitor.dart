part of 'avoid_extends_keyword_rule.dart';

class _ClassVisitor extends RecursiveAstVisitor<void> {
  final _hasRealization = false;

  bool get hasRealization => _hasRealization;

  @override
  void visitVariableDeclaration(VariableDeclaration node) {
    print('');
  }

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    print('');
  }
}
