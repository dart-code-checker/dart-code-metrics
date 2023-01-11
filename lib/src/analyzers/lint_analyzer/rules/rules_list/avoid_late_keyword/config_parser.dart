part of 'avoid_late_keyword_rule.dart';

class _ConfigParser {
  static const _allowInitializedConfig = 'allow-initialized';

  static bool parseAllowInitialized(Map<String, Object> config) =>
      config[_allowInitializedConfig] as bool? ?? false;
}
