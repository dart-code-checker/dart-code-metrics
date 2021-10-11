part of 'prefer_first.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final _expressions = <Expression>[];

  Iterable<Expression> get expressions => _expressions;

  @override
  void visitMethodInvocation(MethodInvocation node) {
    super.visitMethodInvocation(node);

    if (_isIterableOrSubclass(node.realTarget?.staticType) &&
        node.methodName.name == 'elementAt') {
      final arg = node.argumentList.arguments.first;

      if (arg is IntegerLiteral && arg.value == 0) {
        _expressions.add(node);
      }
    }
  }

  @override
  void visitIndexExpression(IndexExpression node) {
    super.visitIndexExpression(node);

    if (_isListOrSubclass(node.realTarget.staticType)) {
      final index = node.index;

      if (index is IntegerLiteral && index.value == 0) {
        _expressions.add(node);
      }
    }
  }

  bool _isIterableOrSubclass(DartType? type) =>
      _isIterable(type) || _isSubclassOfIterable(type);

  bool _isIterable(DartType? type) => type?.isDartCoreIterable ?? false;

  bool _isSubclassOfIterable(DartType? type) =>
      type is InterfaceType && type.allSupertypes.any(_isIterable);

  bool _isListOrSubclass(DartType? type) =>
      _isList(type) || _isSubclassOfList(type);

  bool _isList(DartType? type) => type?.isDartCoreList ?? false;

  bool _isSubclassOfList(DartType? type) =>
      type is InterfaceType && type.allSupertypes.any(_isList);
}
