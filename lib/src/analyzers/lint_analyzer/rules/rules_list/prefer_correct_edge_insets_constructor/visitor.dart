part of 'prefer_correct_edge_insets_constructor_rule.dart';

const _constructorNameFromLTRB = 'fromLTRB';
const _constructorNameSymmetric = 'symmetric';
const _constructorNameOnly = 'only';

class _Visitor extends RecursiveAstVisitor<void> {
  final _expressions = <InstanceCreationExpression, String>{};

  Map<InstanceCreationExpression, String> get expressions => _expressions;

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression expression) {
    super.visitInstanceCreationExpression(expression);

    final constructorName = expression.constructorName.name?.name;
    if (constructorName == _constructorNameFromLTRB) {
      _validateLTRB(expression);
    } else if (constructorName == _constructorNameSymmetric) {
      _validateSymmetric(expression);
    } else if (constructorName == _constructorNameOnly) {
      _validateOnly(expression);
    }
  }

  void _validateLTRB(InstanceCreationExpression expression) {
    if (!expression.argumentList.arguments.every(
      (element) => element is IntegerLiteral || element is DoubleLiteral,
    )) {
      return;
    }

    final argumentsList =
        expression.argumentList.arguments.map((e) => e.toString());

    // EdgeInsets.fromLTRB(0,0,0,0) -> EdgeInsets.zero
    if (argumentsList.every((element) => num.tryParse(element) == 0)) {
      _expressions[expression] = _replaceWithZero();

      return;
    }

    // EdgeInsets.fromLTRB(12,12,12,12) -> EdgeInsets.all(12)
    if (argumentsList.every((element) => element == argumentsList.first)) {
      _expressions[expression] = _replaceWithAll(argumentsList.first);

      return;
    }

    // EdgeInsets.fromLTRB(3,2,3,2) -> EdgeInsets.symmetric(horizontal: 3, vertical: 2)
    if (argumentsList.length == 4 &&
        argumentsList.first == argumentsList.elementAt(2) &&
        argumentsList.elementAt(1) == argumentsList.elementAt(3)) {
      final params = <String>[];
      if (num.tryParse(argumentsList.first) != 0) {
        params.add(
          'horizontal: ${argumentsList.first}',
        );
      }
      if (num.tryParse(argumentsList.elementAt(1)) != 0) {
        params.add(
          'vertical: ${argumentsList.elementAt(1)}',
        );
      }
      _expressions[expression] = _replaceWithSymmetric(params.join(', '));

      return;
    }

    // EdgeInsets.fromLTRB(3,0,0,2) -> EdgeInsets.only(left: 3, bottom: 2)
    if (argumentsList.contains('0') || argumentsList.contains('0.0')) {
      _ltrbToOnly(expression);

      return;
    }
  }

  void _ltrbToOnly(InstanceCreationExpression expression) {
    final params = <String>[];
    for (var index = 0;
        index < expression.argumentList.arguments.length;
        index++) {
      final argumentString =
          expression.argumentList.arguments[index].toString();
      if (num.tryParse(argumentString) != 0) {
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

    _expressions[expression] = _replaceWithOnly(params.join(', '));
  }

  void _validateSymmetric(InstanceCreationExpression expression) {
    if (!expression.argumentList.arguments.every((element) =>
        element.endToken.type == TokenType.INT ||
        element.endToken.type == TokenType.DOUBLE)) {
      return;
    }

    final params = <String, String>{};
    for (final param in expression.argumentList.arguments) {
      params[param.beginToken.toString()] = param.endToken.toString();
    }

    // EdgeInsets.symmetric(horizontal: 0, vertical: 12) -> EdgeInsets.symmetric(vertical: 12)
    // EdgeInsets.symmetric(horizontal: 0, vertical: 0) -> EdgeInsets.zero
    if (params.values.contains('0') || params.values.contains('0.0')) {
      final arguments = _stringArgumentsFromExpression(expression);

      if (arguments.isEmpty) {
        _expressions[expression] = _replaceWithZero();
      } else {
        _expressions[expression] = _replaceWithSymmetric(arguments.join(', '));
      }

      return;
    }

    // EdgeInsets.symmetric(horizontal: 12, vertical: 12) -> EdgeInsets.all(12)
    if (params['horizontal'] == params['vertical']) {
      _expressions[expression] = _replaceWithAll(params['horizontal']);

      return;
    }
  }

  void _validateOnly(InstanceCreationExpression expression) {
    if (!expression.argumentList.arguments.every((element) =>
        element.endToken.type == TokenType.INT ||
        element.endToken.type == TokenType.DOUBLE)) {
      return;
    }
    final params = <String, String>{};
    for (final param in expression.argumentList.arguments) {
      params[param.beginToken.toString()] = param.endToken.toString();
    }

    if (params.isEmpty) {
      return;
    }
    // EdgeInsets.only(left: 0, right: 12) -> EdgeInsets.only(right: 12)
    if (params.values.contains('0') || params.values.contains('0.0')) {
      final params = _stringArgumentsFromExpression(expression);

      if (params.isNotEmpty) {
        _expressions[expression] = _replaceWithOnly(params.join(', '));

        return;
      } else {
        return;
      }
    }
    // EdgeInsets.only(bottom: 10, right: 10, left: 10, top:10) -> EdgeInsets.all(10)
    if (_isOnlyCanBeReplacedWithAll(params)) {
      _expressions[expression] = _replaceWithAll(params.values.first);

      return;
    }
    // EdgeInsets.only(bottom: 10, right: 12, left: 12, top:10) -> EdgeInsets.symmetric(horizontal: 12, vertical: 10)
    if (_isOnlyCanBeReplacedWithSymmetric(params)) {
      final param = 'horizontal: ${params['left']}, vertical: ${params['top']}';
      _expressions[expression] = _replaceWithSymmetric(param);

      return;
    }
    // EdgeInsets.only(bottom: 10, top:10) -> EdgeInsets.symmetric(vertical: 10)
    if (_isOnlyCanBeReplacedWithVertical(params)) {
      final param = 'vertical: ${params['top']}';
      _expressions[expression] = _replaceWithSymmetric(param);
    }
    // EdgeInsets.only(left: 10, right:10) -> EdgeInsets.symmetric(horizontal: 10)
    if (_isOnlyCanBeReplacedWithHorizontal(params)) {
      final param = 'horizontal: ${params['left']}';
      _expressions[expression] = _replaceWithSymmetric(param);
    }
  }

  bool _isOnlyCanBeReplacedWithAll(Map<String, String> params) =>
      params.length == 4 &&
      num.tryParse(params.values.first) != 0 &&
      params.values.every((element) => element == params.values.first);

  bool _isOnlyCanBeReplacedWithSymmetric(Map<String, String> params) =>
      params.length == 4 &&
      params['top'] == params['bottom'] &&
      params['left'] == params['right'];

  bool _isOnlyCanBeReplacedWithVertical(Map<String, String> params) =>
      params.length == 2 &&
      params['top'] != null &&
      params['top'] == params['bottom'];

  bool _isOnlyCanBeReplacedWithHorizontal(Map<String, String> params) =>
      params.length == 2 &&
      params['left'] != null &&
      params['left'] == params['right'];

  List<String> _stringArgumentsFromExpression(
    InstanceCreationExpression expression,
  ) {
    final arguments = <String>[];
    for (final expression in expression.argumentList.arguments) {
      if (num.tryParse(expression.endToken.toString()) != 0) {
        final name = expression.beginToken.toString();
        final value = expression.endToken.toString();
        arguments.add('$name: $value');
      }
    }

    return arguments;
  }

  String _replaceWithZero() => 'EdgeInsets.zero';

  String _replaceWithAll(String? param) => 'EdgeInsets.all($param)';

  String _replaceWithOnly(String? param) => 'EdgeInsets.only($param)';

  String _replaceWithSymmetric(String? param) => 'EdgeInsets.symmetric($param)';
}
