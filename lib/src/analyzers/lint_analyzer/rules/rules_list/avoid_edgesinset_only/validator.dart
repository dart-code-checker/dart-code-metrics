part of 'avoid_edgeinsets_only_rule.dart';

class _Validator {
  final _exceptions = <InstanceCreationExpression, String>{};

  _Validator();

  Map<InstanceCreationExpression, String> get expressions => _exceptions;

  void validate(Map<InstanceCreationExpression, EdgeInsetsData> expressions) {
    for (final expression in expressions.entries) {

      String? exceptionValue;
      exceptionValue = _validateFromOnly(expression.key);

      if (exceptionValue != null) {
        _exceptions[expression.key] = exceptionValue;
      }
    }
  }


  String? _validateFromOnly(InstanceCreationExpression exp) {

      return exp.toString()
          .replaceAll("EdgeInsets", "EdgeInsetsDirectional")
          .replaceAll("left", "leading")
          .replaceAll("right", "trailing");
  }


}