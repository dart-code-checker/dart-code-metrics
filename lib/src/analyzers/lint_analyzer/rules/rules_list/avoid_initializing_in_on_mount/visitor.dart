part of 'avoid_initializing_in_on_mount_rule.dart';

class _Visitor extends SimpleAstVisitor<void> {
  final _expressions = <AssignmentExpression>[];

  Iterable<AssignmentExpression> get expressions => _expressions;

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    super.visitClassDeclaration(node);

    final type = node.extendsClause?.superclass.type;
    if (type == null || !isComponentOrSubclass(type)) {
      return;
    }

    final onMountMethod = node.members.firstWhereOrNull((member) =>
        member is MethodDeclaration &&
        member.name.lexeme == 'onMount' &&
        isOverride(member.metadata));

    if (onMountMethod is MethodDeclaration) {
      final visitor = _AssignmentExpressionVisitor();
      onMountMethod.visitChildren(visitor);

      _expressions.addAll(visitor.wrongAssignments);
    }
  }
}

class _AssignmentExpressionVisitor extends RecursiveAstVisitor<void> {
  final wrongAssignments = <AssignmentExpression>{};

  @override
  void visitAssignmentExpression(AssignmentExpression node) {
    super.visitAssignmentExpression(node);

    final element = node.writeElement;
    if (element is PropertyAccessorElement &&
        element.variable.isFinal &&
        element.variable.isLate) {
      wrongAssignments.add(node);
    }
  }
}
