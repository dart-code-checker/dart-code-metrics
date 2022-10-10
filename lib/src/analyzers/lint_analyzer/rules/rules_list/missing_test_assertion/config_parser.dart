part of 'missing_test_assertion_rule.dart';

class _ConfigParser {
  static const _includeAssertionsConfig = 'include-assertions';
  static const _includeMethodsConfig = 'include-methods';

  static Iterable<String> parseIncludeAssertions(Map<String, Object> config) =>
      config.containsKey(_includeAssertionsConfig) &&
              config[_includeAssertionsConfig] is Iterable
          ? List<String>.from(config[_includeAssertionsConfig] as Iterable)
          : <String>[];

  static Iterable<String> parseIncludeMethods(Map<String, Object> config) =>
      config.containsKey(_includeMethodsConfig) &&
              config[_includeMethodsConfig] is Iterable
          ? List<String>.from(config[_includeMethodsConfig] as Iterable)
          : <String>[];
}
