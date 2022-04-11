part of 'prefer_correct_edge_insets_constructor_rule.dart';

class _Validator {
  final _exceptions = <InstanceCreationExpression, String>{};

  _Validator();

  Map<InstanceCreationExpression, String> get expressions => _exceptions;

  void validate(Map<InstanceCreationExpression, EdgeInsetsData> expressions) {
    for (final expression in expressions.entries) {
      final data = expression.value;

      if (data.constructorName == _constructorNameFromSTEB ||
          data.constructorName == _constructorNameFromLTRB) {
        _validateFromSTEB(expression.key, data);
      }

      if (data.constructorName == _constructorNameSymmetric) {
        _validateSymmetric(expression.key, data);
      }
      if (data.constructorName == _constructorNameOnly) {
        _validateFromOnly(expression.key, data);
      }
    }
  }

  void _validateSymmetric(InstanceCreationExpression key, EdgeInsetsData data) {
    final param = data.params;
    final vertical = param.firstWhereOrNull((e) => e.name == 'vertical')?.value;
    final horizontal =
        param.firstWhereOrNull((e) => e.name == 'horizontal')?.value;

    final isParamsSame = vertical == horizontal && horizontal != null;
    final isAllParamsZero = isParamsSame && horizontal == 0;

    if (isAllParamsZero) {
      _exceptions[key] = _replaceWithZero();
    }

    if (isParamsSame) {
      _exceptions[key] = '${data.className}.all($horizontal)';
    }

    if (horizontal == 0 && vertical != null) {
      _exceptions[key] = _replaceWithSymmetric('vertical: $vertical');
    }
    if (vertical == 0 && horizontal != null) {
      _exceptions[key] = _replaceWithSymmetric('horizontal: $horizontal');
    }
  }

  void _validateFromOnly(InstanceCreationExpression key, EdgeInsetsData data) {
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
        _exceptions[key] = _replaceWithZero();

        return;
      }

      if (paramsList.every((element) => element == top && top != null)) {
        _exceptions[key] = '${data.className}.all(${data.params.first.value})';

        return;
      }

      if (left == right && hasLeftParam && top == bottom && hasTopParam) {
        final params = 'horizontal: $right, vertical: $top';
        _exceptions[key] = _replaceWithSymmetric(params);

        return;
      }

      if (top == bottom && top != 0 && !hasLeftParam && !hasRightParam) {
        _exceptions[key] = _replaceWithSymmetric('vertical: $top');

        return;
      }

      // EdgeInsets.only(left: 10, right:10) -> EdgeInsets.symmetric(vertical: 10)
      if (left == right && right != 0 && !hasTopParam && !hasBottomParam) {
        _exceptions[key] = _replaceWithSymmetric('horizontal: $right');

        return;
      }

      if (paramsList.contains(0)) {
        _exceptions[key] = '${data.className}.only(${[
          if (hasTopParam) 'top: $top',
          if (hasBottomParam) 'bottom: $bottom',
          if (hasLeftParam && data.className == 'EdgeInsetsDirectional')
            'start: $left',
          if (hasLeftParam && data.className == 'EdgeInsets') 'left: $left',
          if (hasRightParam && data.className == 'EdgeInsetsDirectional')
            'end: $right',
          if (hasRightParam && data.className == 'EdgeInsets') 'right: $right',
        ].join(', ')})';

        return;
      }
    }
  }

  void _validateFromSTEB(InstanceCreationExpression key, EdgeInsetsData data) {
    // EdgeInsets.fromLTRB(0,0,0,0) -> EdgeInsets.zero
    if (data.params.every((element) => element.value == 0)) {
      _exceptions[key] = _replaceWithZero();

      return;
    }

    // EdgeInsets.fromLTRB(12,12,12,12) -> EdgeInsets.all(12)
    // EdgeInsetsDirectional.fromSTEB(12,12,12,12) -> EdgeInsetsDirectional.all(12)
    if (data.params
        .every((element) => element.value == data.params.first.value)) {
      _exceptions[key] = '${data.className}.all(${data.params.first.value})';

      return;
    }

    final left = data.params.first.value;
    final top = data.params.elementAt(1).value;
    final right = data.params.elementAt(2).value;
    final bottom = data.params.elementAt(3).value;

    // EdgeInsets.fromLTRB(3,2,3,2) -> EdgeInsets.symmetric(horizontal: 3, vertical: 2)
    if (left == right && top == bottom) {
      final params = <String>[];
      if (left != 0) {
        params.add('horizontal: $left');
      }
      if (top != 0) {
        params.add('vertical: $top');
      }
      _exceptions[key] = _replaceWithSymmetric(params.join(', '));

      return;
    }

    // EdgeInsets.fromLTRB(3,2,3,2) -> EdgeInsets.symmetric(horizontal: 3, vertical: 2)
    if (data.params.any((element) => element.value == 0)) {
      final params = <String>[];

      if (left != 0) {
        if (data.constructorName == 'fromLTRB') {
          params.add('left: $left');
        } else {
          params.add('start: $left');
        }
      }
      if (top != 0) {
        params.add('top: $top');
      }

      if (right != 0) {
        if (data.constructorName == 'fromLTRB') {
          params.add('right: $right');
        } else {
          params.add('end: $right');
        }
      }

      if (bottom != 0) {
        params.add('bottom: $bottom');
      }

      _exceptions[key] = '${data.className}.only(${params.join(', ')})';

      return;
    }
  }

  String _replaceWithZero() => 'EdgeInsets.zero';

  String _replaceWithSymmetric(String? param) => 'EdgeInsets.symmetric($param)';
}
