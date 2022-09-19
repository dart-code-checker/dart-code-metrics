part of 'prefer_correct_test_file_name_rule.dart';

class _ConfigParser {
  static const _namePatternConfig = 'name-pattern';

  static String parseNamePattern(Map<String, Object> config) {
    final raw = config[_namePatternConfig];

    return raw is String ? raw : '_test.dart';
  }
}
