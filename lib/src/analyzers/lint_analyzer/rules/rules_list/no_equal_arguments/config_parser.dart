part of 'no_equal_arguments_rule.dart';

class _ConfigParser {
  static const _ignoredParametersConfig = 'ignored-parameters';

  static Iterable<String> parseIgnoredParameters(Map<String, Object> config) =>
      config.containsKey(_ignoredParametersConfig) &&
              config[_ignoredParametersConfig] is Iterable
          ? List<String>.from(config[_ignoredParametersConfig] as Iterable)
          : <String>[];
}
