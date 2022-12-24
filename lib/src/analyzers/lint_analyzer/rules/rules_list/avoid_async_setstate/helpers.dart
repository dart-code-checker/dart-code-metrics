part of 'avoid_async_setstate_rule.dart';

@pragma('vm:prefer-inline')
bool _isIdentifier(Expression expr, String ident) =>
    expr is Identifier && expr.name == ident;

@pragma('vm:prefer-inline')
bool _isDivergent(Statement stmt) =>
    stmt is ReturnStatement ||
    stmt is ExpressionStatement && stmt.expression is ThrowExpression;

Expression _thisOr(Expression expr) {
  if (expr is PropertyAccess && expr.target is ThisExpression) {
    return expr.propertyName;
  }

  return expr;
}

/// If null, the check was not indicative of whether mounted was true.
bool? _extractMountedCheck(Expression cond) {
  // ![this.]mounted
  if (cond is PrefixExpression &&
      cond.operator.type == TokenType.BANG &&
      _isIdentifier(_thisOr(cond.operand), 'mounted')) {
    return false;
  }

  // [this.]mounted
  if (_isIdentifier(_thisOr(cond), 'mounted')) {
    return true;
  }

  return null;
}

bool _blockDiverges(Statement blk) {
  if (blk is! Block) {
    return _isDivergent(blk);
  }

  return blk.statements.any(_isDivergent);
}
