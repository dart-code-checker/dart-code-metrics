part of 'prefer_conditional_expressions_rule.dart';

class _ConfigParser {
  static const _ignoreNestedConfig = 'ignore-nested';

  static bool parseIgnoreNested(Map<String, Object> config) =>
      (config[_ignoreNestedConfig] as bool?) ?? false;
}
