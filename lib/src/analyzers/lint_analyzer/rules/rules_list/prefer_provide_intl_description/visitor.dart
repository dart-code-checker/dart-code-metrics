part of 'prefer_provide_intl_description_rule.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  static const _supportedMethods = {'message', 'plural', 'gender', 'select'};

  final _declarations = <MethodInvocation>[];

  Iterable<MethodInvocation> get declarations => _declarations;

  @override
  void visitMethodInvocation(MethodInvocation node) {
    super.visitMethodInvocation(node);

    final target = node.realTarget;
    if (target != null &&
        target is SimpleIdentifier &&
        target.name == 'Intl' &&
        _supportedMethods.contains(node.methodName.name) &&
        _withEmptyDescription(node.argumentList)) {
      _declarations.add(node);
    }
  }

  bool _withEmptyDescription(ArgumentList args) =>
      args.arguments.any((argument) =>
          argument is NamedExpression &&
          argument.name.label.name == 'desc' &&
          argument.expression is SimpleStringLiteral &&
          (argument.expression as SimpleStringLiteral).value.isEmpty) ||
      args.arguments.every((argument) =>
          argument is! NamedExpression || argument.name.label.name != 'desc');
}
