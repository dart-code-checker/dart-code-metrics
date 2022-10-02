part of 'prefer_intl_name_rule.dart';

class _Visitor extends IntlBaseVisitor {
  @override
  void checkMethodInvocation(
    MethodInvocation methodInvocation, {
    String? className,
    String? variableName,
    FormalParameterList? parameterList,
  }) {
    final nameExpression = methodInvocation.argumentList.arguments
        .whereType<NamedExpression>()
        .where((argument) => argument.name.label.name == 'name')
        .firstOrNull
        ?.expression
        .as<SimpleStringLiteral>();

    if (nameExpression == null) {
      addIssue(_NotExistNameIssue(methodInvocation.methodName));
    } else if (nameExpression.value !=
        _NotCorrectNameIssue.getNewValue(className, variableName)) {
      addIssue(_NotCorrectNameIssue(className, variableName, nameExpression));
    }
  }
}

class _NotCorrectNameIssue extends IntlBaseIssue {
  final String? className;
  final String? variableName;

  const _NotCorrectNameIssue(
    this.className,
    this.variableName,
    AstNode node,
  ) : super(node);

  static String? getNewValue(String? className, String? variableName) =>
      className != null ? '${className}_$variableName' : variableName;
}

class _NotExistNameIssue extends IntlBaseIssue {
  const _NotExistNameIssue(super.node);
}
