part of 'avoid_nested_conditional_expressions.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final _nestingLevels = <ConditionalExpression, int>{};

  final int _acceptableLevel;

  Iterable<ConditionalExpression> get expressions => _nestingLevels.entries
      .where((entry) => entry.value > _acceptableLevel)
      .map((entry) => entry.key);

  _Visitor(this._acceptableLevel);

  @override
  void visitConditionalExpression(ConditionalExpression node) {
    final parent = _getParentConditionalExpression(node);
    if (_nestingLevels.containsKey(parent)) {
      _nestingLevels[node] = _nestingLevels[parent]! + 1;
    } else {
      _nestingLevels[node] = 1;
    }

    super.visitConditionalExpression(node);
  }

  ConditionalExpression? _getParentConditionalExpression(
    ConditionalExpression expression,
  ) =>
      expression.parent?.thisOrAncestorOfType<ConditionalExpression>();
}
