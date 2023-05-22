part of 'avoid_edgeinsets_only_rule.dart';

const _className = 'EdgeInsets';

const _constructorNameOnly = 'only';

class _Visitor extends RecursiveAstVisitor<void> {
  final _expressions = <InstanceCreationExpression, EdgeInsetsData>{};

  Map<InstanceCreationExpression, EdgeInsetsData> get edgeInsetOnlyExpressions => _expressions;

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression expression) {
    super.visitInstanceCreationExpression(expression);
    final className = expression.staticType?.getDisplayString(
      withNullability: true,
    );
    final constructorName = expression.constructorName.name?.name;

    if (className != _className || constructorName != _constructorNameOnly) {
      return;
    }

    final argumentsList = <EdgeInsetsParam>[];
    for (final expression in expression.argumentList.arguments) {
      final variable = expression.childEntities.last;
      if (variable is IntegerLiteral || variable is DoubleLiteral) {
        final name = expression.beginToken.toString();
        final value = expression.endToken.toString();

        argumentsList.add(EdgeInsetsParam(
          name: name,
          value: num.tryParse(value),
        ));
      }
    }

    if (argumentsList.isNotEmpty) {
      _expressions[expression] = EdgeInsetsData(
        className ?? '',
        constructorName ?? '',
        argumentsList,
      );
    }

  }


}
