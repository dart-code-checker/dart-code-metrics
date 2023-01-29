part of 'no_magic_number_rule.dart';

class _ConfigParser {
  static const _allowedConfigName = 'allowed';

  static const _allowOnlyOnce = 'allow-only-once';

  static const _defaultMagicNumbers = [-1, 0, 1];

  static Iterable<num> parseAllowedNumbers(Map<String, Object> config) =>
      (config[_allowedConfigName] as Iterable?)?.cast<num>() ??
      _defaultMagicNumbers;

  static bool parseAllowOnlyOnce(Map<String, Object> config) =>
      (config[_allowOnlyOnce] as bool?) ?? false;
}
