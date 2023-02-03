part of 'prefer_correct_edge_insets_constructor_rule.dart';

const _className = 'EdgeInsets';
const _classNameDirection = 'EdgeInsetsDirectional';

const _constructorNameFromLTRB = 'fromLTRB';
const _constructorNameFromSTEB = 'fromSTEB';
const _constructorNameSymmetric = 'symmetric';
const _constructorNameOnly = 'only';

class _Visitor extends RecursiveAstVisitor<void> {
  final _expressions = <InstanceCreationExpression, EdgeInsetsData>{};

  Map<InstanceCreationExpression, EdgeInsetsData> get expressions =>
      _expressions;

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression expression) {
    super.visitInstanceCreationExpression(expression);
    final className = expression.staticType?.getDisplayString(
      withNullability: true,
    );
    final constructorName = expression.constructorName.name?.name;

    if (className == _className || className == _classNameDirection) {
      switch (constructorName) {
        case _constructorNameOnly:
        case _constructorNameSymmetric:
          _parseNamedParams(expression, constructorName, className);
          break;
        case _constructorNameFromLTRB:
        case _constructorNameFromSTEB:
          _parsePositionParams(expression, constructorName, className);
          break;
      }
    }
  }

  void _parseNamedParams(
    InstanceCreationExpression expression,
    String? constructorName,
    String? className,
  ) {
    final argumentsList = <EdgeInsetsParam?>[];
    for (final expression in expression.argumentList.arguments) {
      final variable = expression.childEntities.last;
      if (variable is IntegerLiteral || variable is DoubleLiteral) {
        final name = expression.beginToken.toString();
        final value = expression.endToken.toString();

        argumentsList.add(EdgeInsetsParam(
          name: name,
          value: num.tryParse(value),
        ));
      } else {
        argumentsList.add(null);
      }
    }

    if (!argumentsList.contains(null)) {
      final param = argumentsList.whereType<EdgeInsetsParam>().toList();
      _expressions[expression] = EdgeInsetsData(
        className ?? '',
        constructorName ?? '',
        param,
      );
    }
  }

  void _parsePositionParams(
    InstanceCreationExpression expression,
    String? constructorName,
    String? className,
  ) {
    final arguments = expression.argumentList.arguments;
    if (arguments.length == 4 &&
        arguments.every(
          (element) => element is IntegerLiteral || element is DoubleLiteral,
        )) {
      final argumentsList = arguments
          .map((e) => EdgeInsetsParam(value: num.tryParse(e.toString())))
          .toList();

      _expressions[expression] = EdgeInsetsData(
        className ?? '',
        constructorName ?? '',
        argumentsList,
      );
    }
  }
}
