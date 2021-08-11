part of 'prefer_correct_identifier_length.dart';

class _ConfigParser {
  static const _minIdentifierLength = 'min-identifier-length';
  static const _maxIdentifierLength = 'max-identifier-length';

  static const _checkFunctionName = 'check-function-name';
  static const _checkClassName = 'check-class-name';
  static const _checkIdentifierName = 'check-variable-name';

  static int? parseMinIdentifierLength(Map<String, Object> config) {
    final minLength = config[_minIdentifierLength];

    return minLength != null ? int.tryParse(minLength.toString()) : null;
  }

  static int? parseMaxIdentifierLength(Map<String, Object> config) {
    final maxLength = config[_maxIdentifierLength];

    return maxLength != null ? int.tryParse(maxLength.toString()) : null;
  }

  static bool? parseCheckFunctionName(Map<String, Object> config) {
    final value = config[_checkFunctionName];

    return value == null ? null : value.toString().toLowerCase() == 'true';
  }

  static bool? parseCheckClassName(Map<String, Object> config) {
    final value = config[_checkClassName];

    return value == null ? null : value.toString().toLowerCase() == 'true';
  }

  static bool? parseCheckIdentifier(Map<String, Object> config) {
    final value = config[_checkIdentifierName];

    return value == null ? null : value.toString().toLowerCase() == 'true';
  }
}
