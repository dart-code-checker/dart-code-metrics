part of 'prefer_on_push_cd_strategy_rule.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final _expression = <AstNode>[];

  Iterable<AstNode> get expression => _expression;

  @override
  void visitAnnotation(Annotation node) {
    if (!_isComponentAnnotation(node)) {
      return;
    }

    final changeDetectionArg = node.arguments?.arguments
        .whereType<NamedExpression>()
        .firstWhereOrNull((arg) => arg.name.label.name == 'changeDetection');

    if (changeDetectionArg == null) {
      return _expression.add(node);
    }

    final value = changeDetectionArg.expression;
    if (value is PrefixedIdentifier && _isCorrectStrategy(value)) {
      return;
    }

    return _expression.add(changeDetectionArg);
  }

  bool _isCorrectStrategy(PrefixedIdentifier identifier) =>
      identifier.prefix.name == 'ChangeDetectionStrategy' &&
      identifier.identifier.name == 'OnPush';

  bool _isComponentAnnotation(Annotation node) =>
      node.name.name == 'Component' &&
      node.atSign.type == TokenType.AT &&
      node.parent is ClassDeclaration;
}
