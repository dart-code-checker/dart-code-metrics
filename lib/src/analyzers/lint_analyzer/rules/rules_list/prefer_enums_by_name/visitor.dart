part of 'prefer_enums_by_name_rule.dart';

class _Visitor extends RecursiveAstVisitor<void> {
  final _invocations = <MethodInvocation>[];

  Iterable<MethodInvocation> get invocations => _invocations;

  @override
  void visitMethodInvocation(MethodInvocation node) {
    super.visitMethodInvocation(node);

    final target = node.target;
    if (target is PrefixedIdentifier) {
      if (_isEnum(target.prefix) && _hasValuesTarget(target.identifier)) {
        if (node.methodName.name == 'firstWhere') {
          _invocations.add(node);
        }
      }
    }
  }

  bool _isEnum(SimpleIdentifier prefix) =>
      prefix.staticElement?.kind == ElementKind.ENUM;

  bool _hasValuesTarget(SimpleIdentifier identifier) =>
      identifier.name == 'values';
}
