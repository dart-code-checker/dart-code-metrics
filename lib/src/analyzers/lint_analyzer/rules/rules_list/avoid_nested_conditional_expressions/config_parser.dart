part of 'avoid_nested_conditional_expressions.dart';

class _ConfigParser {
  static const _acceptableLevelConfig = 'acceptable-level';

  static const _defaultAcceptableLevel = 1;

  static int getAcceptableLevel(Map<String, Object> config) {
    final level = _getInt(config, _acceptableLevelConfig);

    return level != null && level > 0 ? level : _defaultAcceptableLevel;
  }

  static int? _getInt(Map<String, Object> config, String name) =>
      config[name] is int ? config[name] as int : null;
}
