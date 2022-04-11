part of 'prefer_correct_edge_insets_constructor_rule.dart';

const _className = 'EdgeInsets';
const _classNameDirection = 'EdgeInsetsDirectional';

const _constructorNameFromLTRB = 'fromLTRB';
const _constructorNameFromSTEB = 'fromSTEB';
const _constructorNameSymmetric = 'symmetric';
const _constructorNameOnly = 'only';

class _Visitor extends RecursiveAstVisitor<void> {
  final _expressions = <InstanceCreationExpression, EdgeInsetsData>{};

  final _Validator validator = _Validator();

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
    final argumentsList = <EdgeInsetsParam>[];
    for (final expression in expression.argumentList.arguments) {
      final name = expression.beginToken.toString();
      final value = expression.endToken.toString();
      argumentsList
          .add(EdgeInsetsParam(name: name, value: num.tryParse(value)));
    }

    _expressions[expression] = EdgeInsetsData(
      className ?? '',
      constructorName ?? '',
      argumentsList,
    );
  }

  void _parsePositionParams(
    InstanceCreationExpression expression,
    String? constructorName,
    String? className,
  ) {
    if (expression.argumentList.arguments.length == 4 &&
        expression.argumentList.arguments.every(
          (element) => element is IntegerLiteral || element is DoubleLiteral,
        )) {
      final argumentsList = expression.argumentList.arguments
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
