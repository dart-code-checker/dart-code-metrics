// ignore_for_file: parameter_assignments

part of 'use_setstate_synchronously_rule.dart';

typedef MountedFact = Fact<BinaryExpression>;

extension on BinaryExpression {
  bool get isOr => operator.type == TokenType.BAR_BAR;
  bool get isAnd => operator.type == TokenType.AMPERSAND_AMPERSAND;
}

MountedFact _extractMountedCheck(
  Expression node, {
  bool permitAnd = true,
  bool expandOr = false,
}) {
  // ![this. || context.]mounted
  if (node is PrefixExpression &&
      node.operator.type == TokenType.BANG &&
      _isIdentifier(_thisOrContextOr(node.operand), 'mounted')) {
    return false.asFact();
  }

  // [this. || context.]mounted
  if (_isIdentifier(_thisOrContextOr(node), 'mounted')) {
    return true.asFact();
  }

  if (node is BinaryExpression) {
    final right = node.rightOperand;
    // mounted && ..
    if (node.isAnd && permitAnd) {
      return _extractMountedCheck(node.leftOperand)
          .orElse(() => _extractMountedCheck(right));
    }

    if (node.isOr) {
      if (!expandOr) {
        // Or-chains don't indicate anything in the then-branch yet,
        // but may yield information for the else-branch or divergence analysis.
        return Fact.maybe(node);
      }

      return _extractMountedCheck(
        node.leftOperand,
        expandOr: expandOr,
        permitAnd: permitAnd,
      ).orElse(() => _extractMountedCheck(
            right,
            expandOr: expandOr,
            permitAnd: permitAnd,
          ));
    }
  }

  return const Fact.maybe();
}

/// If [fact] is indeterminate, try to recover a fact from its metadata.
MountedFact _tryInvert(MountedFact fact) {
  final node = fact.info;

  // a || b
  if (node != null && node.isOr) {
    return _extractMountedCheck(
      node.leftOperand,
      expandOr: true,
      permitAnd: false,
    )
        .orElse(
          () => _extractMountedCheck(
            node.rightOperand,
            expandOr: true,
            permitAnd: false,
          ),
        )
        .not;
  }

  return fact.not;
}

@pragma('vm:prefer-inline')
bool _isIdentifier(Expression node, String ident) =>
    node is Identifier && node.name == ident;

@pragma('vm:prefer-inline')
bool _isDivergent(Statement node, {bool allowControlFlow = false}) =>
    node is ReturnStatement ||
    allowControlFlow && (node is BreakStatement || node is ContinueStatement) ||
    node is ExpressionStatement && node.expression is ThrowExpression;

@pragma('vm:prefer-inline')
Expression _thisOrContextOr(Expression node) {
  if (node is PropertyAccess && node.target is ThisExpression) {
    return node.propertyName;
  }

  if (node is PrefixedIdentifier && isBuildContext(node.prefix.staticType)) {
    return node.identifier;
  }

  return node;
}

bool _blockDiverges(Statement block, {required bool allowControlFlow}) => block
        is Block
    ? block.statements
        .any((node) => _isDivergent(node, allowControlFlow: allowControlFlow))
    : _isDivergent(block, allowControlFlow: allowControlFlow);

bool _caseDiverges(SwitchMember arm, {required bool allowControlFlow}) =>
    arm.statements
        .any((node) => _isDivergent(node, allowControlFlow: allowControlFlow));
