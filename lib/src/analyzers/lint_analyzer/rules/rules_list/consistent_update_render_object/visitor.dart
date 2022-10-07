part of 'consistent_update_render_object_rule.dart';

class _Visitor extends GeneralizingAstVisitor<void> {
  final _declarations = <_DeclarationInfo>[];

  Iterable<_DeclarationInfo> get declarations => _declarations;

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    final classType = node.extendsClause?.superclass.type;
    if (!isRenderObjectWidgetOrSubclass(classType)) {
      return;
    }

    final methodsVisitor = _MethodsVisitor();
    node.visitChildren(methodsVisitor);

    final updateDeclaration = methodsVisitor.updateDeclaration;
    final createDeclaration = methodsVisitor.createDeclaration;

    if (createDeclaration == null) {
      return;
    }

    final creationVisitor = _CreationVisitor();
    createDeclaration.visitChildren(creationVisitor);

    final createArgumentsLength =
        _getCountableArgumentsLength(creationVisitor.arguments);
    if (createArgumentsLength == 0) {
      return;
    }

    if (updateDeclaration == null) {
      if (node.abstractKeyword == null) {
        _declarations.add(_DeclarationInfo(
          node,
          'Implementation for updateRenderObject method is absent.',
        ));
      }

      return;
    }

    final propertyAccessVisitor = _PropertyAccessVisitor();
    updateDeclaration.visitChildren(propertyAccessVisitor);

    if (createArgumentsLength != propertyAccessVisitor.propertyAccess.length) {
      _declarations.add(_DeclarationInfo(
        updateDeclaration,
        "updateRenderObject method doesn't update all parameters, that are set in createRenderObject",
      ));
    }
  }

  int _getCountableArgumentsLength(List<Expression> arguments) =>
      arguments.where(
        (argument) {
          final expression =
              argument is NamedExpression ? argument.expression : argument;

          return expression is! NullLiteral &&
              !isRenderObjectElementOrSubclass(expression.staticType);
        },
      ).length;
}

class _MethodsVisitor extends GeneralizingAstVisitor<void> {
  MethodDeclaration? createDeclaration;

  MethodDeclaration? updateDeclaration;

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    final name = node.name.lexeme;
    if (name == 'updateRenderObject') {
      updateDeclaration = node;
    } else if (name == 'createRenderObject') {
      createDeclaration = node;
    }
  }
}

class _CreationVisitor extends RecursiveAstVisitor<void> {
  final arguments = <Expression>[];

  @override
  void visitReturnStatement(ReturnStatement node) {
    super.visitReturnStatement(node);

    final expression = node.expression;

    if (expression is InstanceCreationExpression) {
      arguments.addAll(expression.argumentList.arguments);
    }
  }

  @override
  void visitExpressionFunctionBody(ExpressionFunctionBody node) {
    super.visitExpressionFunctionBody(node);

    final expression = node.expression;

    if (expression is InstanceCreationExpression) {
      arguments.addAll(expression.argumentList.arguments);
    }
  }
}

class _PropertyAccessVisitor extends RecursiveAstVisitor<void> {
  final propertyAccess = <Expression>[];

  @override
  void visitAssignmentExpression(AssignmentExpression node) {
    super.visitAssignmentExpression(node);

    final expression = node.leftHandSide;

    if (expression is PropertyAccess) {
      propertyAccess.add(expression);
    } else if (expression is PrefixedIdentifier) {
      propertyAccess.add(expression);
    }
  }
}

class _DeclarationInfo {
  final Declaration node;
  final String errorMessage;

  const _DeclarationInfo(this.node, this.errorMessage);
}
