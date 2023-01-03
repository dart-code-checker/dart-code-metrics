part of 'avoid_unused_parameters_rule.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final _unusedParameters = <FormalParameter>[];

  Iterable<FormalParameter> get unusedParameters => _unusedParameters;

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    super.visitMethodDeclaration(node);

    final parent = node.parent;
    final parameters = node.parameters;

    if (parent is ClassDeclaration && parent.abstractKeyword != null ||
        node.isAbstract ||
        node.externalKeyword != null ||
        (parameters == null || parameters.parameters.isEmpty)) {
      return;
    }

    final isTearOff = _usedAsTearOff(node);

    if (!isOverride(node.metadata) && !isTearOff) {
      _unusedParameters.addAll(
        _getUnusedParameters(
          node.body,
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
        node.functionExpression.body,
        parameters.parameters,
      ).where(_hasNoUnderscoresInName),
    );
  }

  Set<FormalParameter> _getUnusedParameters(
    AstNode body,
    Iterable<FormalParameter> parameters,
  ) {
    final result = <FormalParameter>{};
    final visitor = _IdentifiersVisitor();
    body.visitChildren(visitor);

    final allIdentifierElements = visitor.elements;

    for (final parameter in parameters) {
      final name = parameter.name;
      if (name != null &&
          !allIdentifierElements.contains(parameter.declaredElement)) {
        result.add(parameter);
      }
    }

    return result;
  }

  bool _hasNoUnderscoresInName(FormalParameter parameter) =>
      parameter.name != null &&
      parameter.name!.lexeme.replaceAll('_', '').isNotEmpty;

  bool _usedAsTearOff(MethodDeclaration node) {
    final name = node.name.lexeme;
    if (!Identifier.isPrivateName(name)) {
      return false;
    }

    final visitor = _InvocationsVisitor(name);
    node.root.visitChildren(visitor);

    return visitor.hasTearOffInvocations;
  }
}

class _IdentifiersVisitor extends RecursiveAstVisitor<void> {
  final elements = <Element>{};

  @override
  void visitSimpleIdentifier(SimpleIdentifier node) {
    super.visitSimpleIdentifier(node);

    final element = node.staticElement;
    if (element != null) {
      elements.add(element);
    }
  }
}

class _InvocationsVisitor extends RecursiveAstVisitor<void> {
  final String methodName;

  bool hasTearOffInvocations = false;

  _InvocationsVisitor(this.methodName);

  @override
  void visitSimpleIdentifier(SimpleIdentifier node) {
    if (node.name == methodName &&
        node.staticElement is MethodElement &&
        node.parent is ArgumentList) {
      hasTearOffInvocations = true;
    }

    super.visitSimpleIdentifier(node);
  }
}
