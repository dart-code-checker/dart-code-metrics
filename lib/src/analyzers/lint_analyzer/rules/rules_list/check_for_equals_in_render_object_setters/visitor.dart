part of 'check_for_equals_in_render_object_setters_rule.dart';

class _Visitor extends GeneralizingAstVisitor<void> {
  final _declarations = <_DeclarationInfo>[];

  Iterable<_DeclarationInfo> get declarations => _declarations;

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    final classType = node.extendsClause?.superclass.type;
    if (!isRenderObjectOrSubclass(classType)) {
      return;
    }

    final settersVisitor = _SettersVisitor();
    node.visitChildren(settersVisitor);

    _declarations.addAll(settersVisitor.declarations);
  }
}

class _SettersVisitor extends GeneralizingAstVisitor<void> {
  final _declarations = <_DeclarationInfo>[];

  Iterable<_DeclarationInfo> get declarations => _declarations;

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    if (!node.isSetter) {
      return;
    }

    final body = node.body;

    var notFirst = false;

    if (body is BlockFunctionBody) {
      for (final statement in body.block.statements) {
        if (statement is IfStatement) {
          if (notFirst) {
            _declarations.add(_DeclarationInfo(
              node,
              'Equals check should come first in the block.',
            ));

            return;
          }

          final returnVisitor = _ReturnVisitor();
          statement.visitChildren(returnVisitor);

          // ignore: deprecated_member_use
          final condition = statement.condition;
          if (condition is BinaryExpression) {
            if (!(_usesParameter(condition.leftOperand) ||
                _usesParameter(condition.rightOperand) &&
                    returnVisitor.isValid)) {
              _declarations.add(_DeclarationInfo(
                node,
                'Equals check compares a wrong parameter or has no return statement.',
              ));
            }
          }

          return;
        }

        if (statement is! AssertStatement &&
            statement is! VariableDeclarationStatement) {
          notFirst = true;
        }
      }
    }

    if (notFirst) {
      _declarations.add(_DeclarationInfo(
        node,
        'Equals check is missing.',
      ));
    }
  }

  bool _usesParameter(Expression expression) =>
      expression is SimpleIdentifier &&
      expression.staticElement is ParameterElement;
}

class _ReturnVisitor extends RecursiveAstVisitor<void> {
  bool _hasValidReturn = false;

  bool _hasValidAssignment = false;

  bool get isValid => _hasValidReturn || _hasValidAssignment;

  @override
  void visitReturnStatement(ReturnStatement node) {
    super.visitReturnStatement(node);

    final type = node.expression?.staticType;

    // ignore: deprecated_member_use
    if (type == null || type.isVoid) {
      _hasValidReturn = true;
    }
  }

  @override
  void visitAssignmentExpression(AssignmentExpression node) {
    super.visitAssignmentExpression(node);

    _hasValidAssignment = true;
  }
}

class _DeclarationInfo {
  final Declaration node;
  final String errorMessage;

  const _DeclarationInfo(this.node, this.errorMessage);
}
