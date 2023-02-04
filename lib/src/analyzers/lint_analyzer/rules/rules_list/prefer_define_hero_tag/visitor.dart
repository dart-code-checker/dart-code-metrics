part of 'prefer_define_hero_tag_rule.dart';

const _floatingActionButtonClassName = 'FloatingActionButton';
const _constructorExtendedName = 'extended';
const _constructorLargeName = 'large';
const _constructorSmallName = 'small';
const _heroTagPropertyName = 'heroTag';

class _Visitor extends RecursiveAstVisitor<void> {
  final _invocations = <MethodInvocation>[];

  Iterable<MethodInvocation> get invocations => _invocations;

  @override
  void visitMethodInvocation(MethodInvocation node) {
    super.visitMethodInvocation(node);

    final methodName = node.methodName.name;
    if (methodName == _floatingActionButtonClassName ||
        node.beginToken.lexeme == _floatingActionButtonClassName &&
            (methodName == _constructorExtendedName ||
                methodName == _constructorLargeName ||
                methodName == _constructorSmallName)) {
      if (!node.argumentList.arguments
          .cast<NamedExpression>()
          .any((arg) => arg.name.label.name == _heroTagPropertyName)) {
        _invocations.add(node);
      }
    }
  }
}
