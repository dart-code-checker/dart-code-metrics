part of 'avoid_nested_conditional_expressions_rule.dart';

class _ConfigParser {
  static const _acceptableLevelConfig = 'acceptable-level';

  static const _defaultAcceptableLevel = 1;

  static int parseAcceptableLevel(Map<String, Object> config) {
    final level = _parseIntConfig(config, _acceptableLevelConfig);

    return level != null && level > 0 ? level : _defaultAcceptableLevel;
  }

  static int? _parseIntConfig(Map<String, Object> config, String name) =>
      config[name] != null ? int.tryParse(config[name].toString()) : null;
}
