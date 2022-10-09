part of 'missing_test_assertion_rule.dart';

class _ConfigParser {
  static const _includeAssertionsConfig = 'include-assertions';

  static Iterable<String> parseIncludeAssertions(Map<String, Object> config) =>
      config.containsKey(_includeAssertionsConfig) &&
              config[_includeAssertionsConfig] is Iterable
          ? List<String>.from(config[_includeAssertionsConfig] as Iterable)
          : <String>[];
}
