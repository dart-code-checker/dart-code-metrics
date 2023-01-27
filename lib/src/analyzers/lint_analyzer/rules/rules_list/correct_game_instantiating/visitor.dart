part of 'correct_game_instantiating_rule.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final _info = <_InstantiationInfo>[];

  Iterable<_InstantiationInfo> get info => _info;

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    super.visitClassDeclaration(node);

    final type = node.extendsClause?.superclass.type;
    if (type == null) {
      return;
    }

    final isWidget = isWidgetOrSubclass(type);
    final isWidgetState = isWidgetStateOrSubclass(type);
    if (!isWidget && !isWidgetState) {
      return;
    }

    final declaration = node.members.firstWhereOrNull((declaration) =>
        declaration is MethodDeclaration && declaration.name.lexeme == 'build');

    if (declaration is MethodDeclaration) {
      final visitor = _GameWidgetInstantiatingVisitor();
      declaration.visitChildren(visitor);

      if (visitor.wrongInstantiation != null) {
        _info.add(_InstantiationInfo(
          visitor.wrongInstantiation!,
          isStateless: !isWidgetState,
        ));
      }
    }
  }
}

class _GameWidgetInstantiatingVisitor extends RecursiveAstVisitor<void> {
  InstanceCreationExpression? wrongInstantiation;

  _GameWidgetInstantiatingVisitor();

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    super.visitInstanceCreationExpression(node);

    if (isGameWidget(node.staticType) &&
        node.constructorName.name?.name != 'controlled') {
      final gameArgument = node.argumentList.arguments.firstWhereOrNull(
        (argument) =>
            argument is NamedExpression && argument.name.label.name == 'game',
      );

      if (gameArgument is NamedExpression &&
          gameArgument.expression is InstanceCreationExpression) {
        wrongInstantiation = node;
      }
    }
  }
}

class _InstantiationInfo {
  final bool isStateless;
  final InstanceCreationExpression node;

  const _InstantiationInfo(this.node, {required this.isStateless});
}
