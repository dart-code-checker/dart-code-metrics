part of 'avoid_unused_parameters_rule.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final _unusedParameters = <FormalParameter>[];

  Iterable<FormalParameter> get unusedParameters => _unusedParameters;

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    super.visitMethodDeclaration(node);

    final parent = node.parent;
    final parameters = node.parameters;

    if (parent is ClassDeclaration && parent.isAbstract ||
        node.isAbstract ||
        node.externalKeyword != null ||
        (parameters == null || parameters.parameters.isEmpty)) {
      return;
    }

    final isOverride = node.metadata.any(
      (node) =>
          node.name.name == 'override' && node.atSign.type == TokenType.AT,
    );

    if (!isOverride) {
      _unusedParameters.addAll(
        _getUnusedParameters(
          node.body.childEntities,
          parameters.parameters,
        ).where(_hasNoUnderscoresInName),
      );
    }
  }

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    super.visitFunctionDeclaration(node);

    final parameters = node.functionExpression.parameters;

    if (node.externalKeyword != null ||
        (parameters == null || parameters.parameters.isEmpty)) {
      return;
    }

    _unusedParameters.addAll(
      _getUnusedParameters(
        node.functionExpression.body.childEntities,
        parameters.parameters,
      ).where(_hasNoUnderscoresInName),
    );
  }

  Iterable<FormalParameter> _getUnusedParameters(
    Iterable<SyntacticEntity> children,
    Iterable<FormalParameter> parameters,
  ) {
    final result = <FormalParameter>[];

    final names = parameters
        .map((parameter) => parameter.identifier?.name)
        .whereNotNull()
        .toList();
    final usedNames = _getUsedNames(children, names, []);

    for (final parameter in parameters) {
      final name = parameter.identifier?.name;
      if (name != null && !usedNames.contains(name)) {
        result.add(parameter);
      }
    }

    return result;
  }

  Iterable<String> _getUsedNames(
    Iterable<SyntacticEntity> children,
    List<String> parametersNames,
    Iterable<String> ignoredNames,
  ) {
    final usedNames = <String>[];
    final ignoredForSubtree = [...ignoredNames];

    if (parametersNames.isEmpty) {
      return usedNames;
    }

    for (final child in children) {
      if (child is FunctionExpression) {
        final parameters = child.parameters;
        if (parameters != null) {
          for (final parameter in parameters.parameters) {
            final name = parameter.identifier?.name;
            if (name != null) {
              ignoredForSubtree.add(name);
            }
          }
        }
      } else if (child is Identifier &&
          parametersNames.contains(child.name) &&
          !ignoredForSubtree.contains(child.name) &&
          !(child.parent is PropertyAccess &&
              (child.parent as PropertyAccess).target != child)) {
        final name = child.name;

        parametersNames.remove(name);
        usedNames.add(name);
      }

      if (child is AstNode) {
        usedNames.addAll(_getUsedNames(
          child.childEntities,
          parametersNames,
          ignoredForSubtree,
        ));
      }
    }

    return usedNames;
  }

  bool _hasNoUnderscoresInName(FormalParameter parameter) =>
      parameter.identifier != null &&
      parameter.identifier!.name.replaceAll('_', '').isNotEmpty;
}
