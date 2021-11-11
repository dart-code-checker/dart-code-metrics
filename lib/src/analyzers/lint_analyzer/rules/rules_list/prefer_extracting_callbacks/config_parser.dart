part of 'prefer_extracting_callbacks_rule.dart';

class _ConfigParser {
  static const _ignoredArgumentsConfig = 'ignored-named-arguments';

  static Iterable<String> parseIgnoredArguments(Map<String, Object> config) =>
      config.containsKey(_ignoredArgumentsConfig) &&
              config[_ignoredArgumentsConfig] is Iterable
          ? List<String>.from(config[_ignoredArgumentsConfig] as Iterable)
          : <String>[];
}
