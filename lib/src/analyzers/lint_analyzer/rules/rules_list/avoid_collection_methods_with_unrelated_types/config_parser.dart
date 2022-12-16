part of 'avoid_collection_methods_with_unrelated_types_rule.dart';

class _ConfigParser {
  static const _strictConfig = 'strict';

  static bool parseIsStrictMode(Map<String, Object> config) =>
      config[_strictConfig] == null || config[_strictConfig] == true;
}
