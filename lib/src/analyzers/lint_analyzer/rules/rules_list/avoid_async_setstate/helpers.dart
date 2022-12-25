part of 'avoid_async_setstate_rule.dart';

@pragma('vm:prefer-inline')
bool _isIdentifier(Expression node, String ident) =>
    node is Identifier && node.name == ident;

@pragma('vm:prefer-inline')
bool _isDivergent(Statement node) =>
    node is ReturnStatement ||
    node is ExpressionStatement && node.expression is ThrowExpression;

Expression _thisOr(Expression node) {
  if (node is PropertyAccess && node.target is ThisExpression) {
    return node.propertyName;
  }

  return node;
}

/// If null, the check was not indicative of whether mounted was true.
bool? _extractMountedCheck(Expression condition) {
  // ![this.]mounted
  if (condition is PrefixExpression &&
      condition.operator.type == TokenType.BANG &&
      _isIdentifier(_thisOr(condition.operand), 'mounted')) {
    return false;
  }

  // [this.]mounted
  if (_isIdentifier(_thisOr(condition), 'mounted')) {
    return true;
  }

  return null;
}

bool _blockDiverges(Statement block) {
  if (block is! Block) {
    return _isDivergent(block);
  }

  return block.statements.any(_isDivergent);
}
