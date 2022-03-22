part of 'prefer_correct_edge_insets_constructor_rule.dart';

const _className = 'EdgeInsets';

const _constructorNameFromLTRB = 'fromLTRB';
const _constructorNameSymmetric = 'symmetric';
const _constructorNameOnly = 'only';

class _Visitor extends RecursiveAstVisitor<void> {
  final _expressions = <InstanceCreationExpression, String>{};

  Map<InstanceCreationExpression, String> get expressions => _expressions;

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression expression) {
    super.visitInstanceCreationExpression(expression);

    final className = expression.staticType?.getDisplayString(
      withNullability: true,
    );

    if (className == _className) {
      final constructorName = expression.constructorName.name;

      if (constructorName?.name == _constructorNameFromLTRB) {
        _validateLTRB(expression);
      } else if (constructorName?.name == _constructorNameSymmetric) {
        _validateSymmetric(expression);
      } else if (constructorName?.name == _constructorNameOnly) {
        _validateOnly(expression);
      }
    }
  }

  void _removeZeroParamsFromSymmetric(InstanceCreationExpression expression) {
    final params = <String>[];

    expression.argumentList.arguments.map((e) {
      if (e.endToken.toString() != '0') {
        params.add(
          '${e.beginToken.toString()}: ${e.endToken.toString()}',
        );
      }
    });
    _expressions[expression] = 'EdgeInsets.symmetric(${params.join(', ')})';
  }

  void _validateLTRB(InstanceCreationExpression expression) {
    final argumentsList =
        expression.argumentList.arguments.map((e) => e.toString());

    // EdgeInsets.fromLTRB(12,12,12,12) -> EdgeInsets.all(12)
    if (argumentsList.every((element) => element == argumentsList.first)) {
      _expressions[expression] = 'EdgeInsets.all(${argumentsList.first})';

      return;
    }

    // EdgeInsets.fromLTRB(3,2,3,2) -> EdgeInsets.symmetric(horizontal: 3, vertical: 2)
    if (argumentsList.length == 4 &&
        argumentsList.first == argumentsList.elementAt(2) &&
        argumentsList.elementAt(1) == argumentsList.elementAt(3)) {
      final params = <String>[];
      if (argumentsList.first != '0') {
        params.add(
          'horizontal: ${argumentsList.first}',
        );
      }
      if (argumentsList.elementAt(1) != '0') {
        params.add(
          'vertical: ${argumentsList.elementAt(1)}',
        );
      }
      _expressions[expression] = 'EdgeInsets.symmetric(${params.join(', ')})';

      return;
    }

    // EdgeInsets.fromLTRB(3,0,0,2) -> EdgeInsets.only(left: 3, bottom: 2)
    if (argumentsList.contains('0')) {
      final params = <String>[];
      for (var index = 0;
          index < expression.argumentList.arguments.length;
          index++) {
        final argumentString =
            expression.argumentList.arguments[index].toString();
        if (argumentString != '0') {
          switch (index) {
            case 0:
              params.add('left: $argumentString');
              break;
            case 1:
              params.add('top: $argumentString');
              break;
            case 2:
              params.add('right: $argumentString');
              break;
            case 3:
              params.add('bottom: $argumentString');
              break;
          }
        }
      }

      _expressions[expression] = 'EdgeInsets.only(${params.join(', ')})';

      return;
    }
  }

  void _validateSymmetric(InstanceCreationExpression expression) {
    final params = <String, String>{};
    for (final param in expression.argumentList.arguments) {
      params[param.beginToken.toString()] = param.endToken.toString();
    }

    _removeZeroParamsFromSymmetric(expression);

    if (params['horizontal'] == params['vertical']) {
      _expressions[expression] = 'EdgeInsets.all(${params['horizontal']})';

      return;
    }
  }

  void _validateOnly(InstanceCreationExpression expression) {
    final params = <String, String>{};
    for (final param in expression.argumentList.arguments) {
      params[param.beginToken.toString()] = param.endToken.toString();
    }

    if (params.values.contains('0')) {
      final params = <String>[];

      for (final argument in expression.argumentList.arguments) {
        if (argument.endToken.toString() != '0') {
          params.add(
            '${argument.beginToken.toString()}: ${argument.endToken.toString()}',
          );
        }
      }

      if (params.isEmpty) {
        _expressions[expression] = 'EdgeInsets.zero';
      } else {
        _expressions[expression] = 'EdgeInsets.only(${params.join(', ')})';
      }

      return;
    }

    if (params.length == 4 &&
        params['top'] == params['bottom'] &&
        params['left'] == params['right']) {
      _expressions[expression] =
          'EdgeInsets.symmetric(horizontal: ${params['left']}, vertical: ${params['top']})';

      return;
    }

    if (params.length == 2 && params['top'] == params['bottom']) {
      _expressions[expression] =
          'EdgeInsets.symmetric(vertical: ${params['top']})';

      return;
    }

    if (params.length == 2 && params['left'] == params['right']) {
      _expressions[expression] =
          'EdgeInsets.symmetric(horizontal: ${params['left']})';

      return;
    }
  }
}
