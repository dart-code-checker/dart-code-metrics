part of 'use_setstate_synchronously_rule.dart';

/// If null, the check was not indicative of whether mounted was true.
bool? _extractMountedCheck(Expression node) {
  // ![this.]mounted
  if (node is PrefixExpression &&
      node.operator.type == TokenType.BANG &&
      _isIdentifier(_thisOr(node.operand), 'mounted')) {
    return false;
  }

  // [this.]mounted
  if (_isIdentifier(_thisOr(node), 'mounted')) {
    return true;
  }

  // mounted && ..
  if (node is BinaryExpression &&
      node.operator.type == TokenType.AMPERSAND_AMPERSAND) {
    return _extractMountedCheck(node.leftOperand) ??
        _extractMountedCheck(node.rightOperand);
  }

  return null;
}

@pragma('vm:prefer-inline')
bool _isIdentifier(Expression node, String ident) =>
    node is Identifier && node.name == ident;

@pragma('vm:prefer-inline')
bool _isDivergent(Statement node) =>
    node is ReturnStatement ||
    node is ExpressionStatement && node.expression is ThrowExpression;

@pragma('vm:prefer-inline')
Expression _thisOr(Expression node) =>
    node is PropertyAccess && node.target is ThisExpression
        ? node.propertyName
        : node;

bool _blockDiverges(Statement block) =>
    block is Block ? block.statements.any(_isDivergent) : _isDivergent(block);
