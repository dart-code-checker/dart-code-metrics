part of 'avoid_creating_vector_in_update_rule.dart';

class _Visitor extends SimpleAstVisitor<void> {
  final _expressions = <Expression>[];

  Iterable<Expression> get expressions => _expressions;

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    super.visitClassDeclaration(node);

    final type = node.extendsClause?.superclass.type;
    if (type == null || !isComponentOrSubclass(type)) {
      return;
    }

    final updateMethod = node.members.firstWhereOrNull((member) =>
        member is MethodDeclaration &&
        member.name.lexeme == 'update' &&
        isOverride(member.metadata));

    if (updateMethod is MethodDeclaration) {
      final visitor = _VectorVisitor();
      updateMethod.visitChildren(visitor);

      _expressions.addAll(visitor.wrongExpressions);
    }
  }
}

class _VectorVisitor extends RecursiveAstVisitor<void> {
  final wrongExpressions = <Expression>{};

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    super.visitInstanceCreationExpression(node);

    if (isVector(node.staticType)) {
      wrongExpressions.add(node);
    }
  }

  @override
  void visitBinaryExpression(BinaryExpression node) {
    super.visitBinaryExpression(node);

    if (isVector(node.leftOperand.staticType) &&
        isVector(node.rightOperand.staticType)) {
      wrongExpressions.add(node);
    }
  }
}
