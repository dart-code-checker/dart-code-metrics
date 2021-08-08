part of 'prefer_correct_identifier_length.dart';

class _ConfigParser {
  static const _minIdentifierLength = 'min-identifier-length';
  static const _maxIdentifierLength = 'max-identifier-length';

  static int? parseMinIdentifierLength(Map<String, Object> config) {
    final minLength = config[_minIdentifierLength];
    return minLength != null ? int.tryParse(minLength.toString()) : null;
  }

  static int? parseMaxIdentifierLength(Map<String, Object> config) {
    final maxLength = config[_maxIdentifierLength];
    return maxLength != null ? int.tryParse(maxLength.toString()) : null;
  }
}
