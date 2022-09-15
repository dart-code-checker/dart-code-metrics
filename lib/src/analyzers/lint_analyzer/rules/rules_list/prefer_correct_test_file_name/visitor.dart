// ignore_for_file: deprecated_member_use

part of 'prefer_correct_test_file_name_rule.dart';

class _Visitor extends GeneralizingAstVisitor<void> {
  final String path;
  final String pattern;

  final _declarations = <FunctionDeclaration>[];

  Iterable<FunctionDeclaration> get declaration => _declarations;

  _Visitor(this.path, this.pattern);

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    if (node.name2.lexeme != 'main' || _matchesTestName(path)) {
      return;
    }

    _declarations.add(node);
  }

  bool _matchesTestName(String path) => path.endsWith(pattern);
}
