part of 'avoid_unnecessary_conditionals_rule.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final _conditionalsInfo = <_ConditionalInfo>[];

  Iterable<_ConditionalInfo> get conditionalsInfo => _conditionalsInfo;

  _Visitor();

  @override
  void visitConditionalExpression(ConditionalExpression node) {
    super.visitConditionalExpression(node);

    final thenExpression = node.thenExpression;
    final elseExpression = node.elseExpression;

    if (thenExpression is BooleanLiteral && elseExpression is BooleanLiteral) {
      final isInverted = !thenExpression.value && elseExpression.value;

      _conditionalsInfo.add(
        _ConditionalInfo(expression: node, isInverted: isInverted),
      );
    }
  }
}

class _ConditionalInfo {
  final ConditionalExpression expression;
  final bool isInverted;

  const _ConditionalInfo({
    required this.expression,
    required this.isInverted,
  });
}
