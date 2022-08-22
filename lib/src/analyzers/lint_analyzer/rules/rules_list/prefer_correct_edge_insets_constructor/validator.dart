part of 'prefer_correct_edge_insets_constructor_rule.dart';

class _Validator {
  final _exceptions = <InstanceCreationExpression, String>{};

  _Validator();

  Map<InstanceCreationExpression, String> get expressions => _exceptions;

  void validate(Map<InstanceCreationExpression, EdgeInsetsData> expressions) {
    for (final expression in expressions.entries) {
      final data = expression.value;

      String? exceptionValue;
      switch (data.constructorName) {
        case _constructorNameFromSTEB:
        case _constructorNameFromLTRB:
          exceptionValue = _validateFromSTEB(data);
          break;
        case _constructorNameSymmetric:
          exceptionValue = _validateSymmetric(data);
          break;
        case _constructorNameOnly:
          exceptionValue = _validateFromOnly(data);
          break;
      }

      if (exceptionValue != null) {
        _exceptions[expression.key] = exceptionValue;
      }
    }
  }

  String? _validateSymmetric(EdgeInsetsData data) {
    final param = data.params;
    final vertical = param.firstWhereOrNull((e) => e.name == 'vertical')?.value;
    final horizontal =
        param.firstWhereOrNull((e) => e.name == 'horizontal')?.value;

    final isParamsSame = vertical == horizontal && horizontal != null;
    final isAllParamsZero = isParamsSame && horizontal == 0;

    if (isAllParamsZero) {
      return _replaceWithZero();
    }

    if (isParamsSame) {
      return 'const ${data.className}.all($horizontal)';
    }

    if (horizontal == 0 && vertical != null) {
      return _replaceWithSymmetric('vertical: $vertical');
    }
    if (vertical == 0 && horizontal != null) {
      return _replaceWithSymmetric('horizontal: $horizontal');
    }

    return null;
  }

  String? _validateFromOnly(EdgeInsetsData data) {
    {
      final param = data.params;
      final top = param.firstWhereOrNull((e) => e.name == 'top')?.value;
      final bottom = param.firstWhereOrNull((e) => e.name == 'bottom')?.value;
      final left = param
          .firstWhereOrNull((e) => e.name == 'left' || e.name == 'start')
          ?.value;
      final right = param
          .firstWhereOrNull((e) => e.name == 'right' || e.name == 'end')
          ?.value;

      final paramsList = [top, bottom, left, right];
      final hasLeftParam = left != 0 && left != null;
      final hasTopParam = top != 0 && top != null;
      final hasBottomParam = bottom != 0 && bottom != null;
      final hasRightParam = right != 0 && right != null;
      if (paramsList.every((element) => element == 0)) {
        return _replaceWithZero();
      }

      if (paramsList.every((element) => element == top && top != null)) {
        return 'const ${data.className}.all(${data.params.first.value})';
      }

      if (left == right && hasLeftParam && top == bottom && hasTopParam) {
        final params = 'horizontal: $right, vertical: $top';

        return _replaceWithSymmetric(params);
      }

      if (top == bottom && top != 0 && !hasLeftParam && !hasRightParam) {
        return _replaceWithSymmetric('vertical: $top');
      }

      if (left == right && right != 0 && !hasTopParam && !hasBottomParam) {
        return _replaceWithSymmetric('horizontal: $right');
      }

      if (paramsList.contains(0)) {
        return 'const ${data.className}.only(${[
          if (hasTopParam) 'top: $top',
          if (hasBottomParam) 'bottom: $bottom',
          if (hasLeftParam && data.className == 'EdgeInsetsDirectional')
            'start: $left',
          if (hasLeftParam && data.className == 'EdgeInsets') 'left: $left',
          if (hasRightParam && data.className == 'EdgeInsetsDirectional')
            'end: $right',
          if (hasRightParam && data.className == 'EdgeInsets') 'right: $right',
        ].join(', ')})';
      }
    }

    return null;
  }

  String? _validateFromSTEB(
    EdgeInsetsData data,
  ) {
    if (data.params.every((element) => element.value == 0)) {
      return _replaceWithZero();
    }

    if (data.params
        .every((element) => element.value == data.params.first.value)) {
      return 'const ${data.className}.all(${data.params.first.value})';
    }

    final left = data.params.first.value;
    final top = data.params.elementAt(1).value;
    final right = data.params.elementAt(2).value;
    final bottom = data.params.elementAt(3).value;

    if (left == right && top == bottom) {
      final params = <String>[];
      if (left != 0) {
        params.add('horizontal: $left');
      }
      if (top != 0) {
        params.add('vertical: $top');
      }

      return _replaceWithSymmetric(params.join(', '));
    }

    if (data.params.any((element) => element.value == 0)) {
      final params = <String>[];

      if (left != 0) {
        if (data.constructorName == _constructorNameFromLTRB) {
          params.add('left: $left');
        } else {
          params.add('start: $left');
        }
      }
      if (top != 0) {
        params.add('top: $top');
      }

      if (right != 0) {
        if (data.constructorName == _constructorNameFromLTRB) {
          params.add('right: $right');
        } else {
          params.add('end: $right');
        }
      }

      if (bottom != 0) {
        params.add('bottom: $bottom');
      }

      return 'const ${data.className}.only(${params.join(', ')})';
    }

    return null;
  }

  String _replaceWithZero() => 'EdgeInsets.zero';

  String _replaceWithSymmetric(String? param) =>
      'const EdgeInsets.symmetric($param)';
}
