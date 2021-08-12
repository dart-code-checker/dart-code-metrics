part of 'prefer_correct_identifier_length.dart';

class _ConfigParser {
  static const _minIdentifierLength = 'min-identifier-length';
  static const _maxIdentifierLength = 'max-identifier-length';

  static const _checkFunctionName = 'check-function-name';
  static const _checkClassName = 'check-class-name';
  static const _checkIdentifierName = 'check-variable-name';

  static int? parseMinIdentifierLength(Map<String, Object> config) =>
      _parseIntConfig(config[_minIdentifierLength]);

  static int? parseMaxIdentifierLength(Map<String, Object> config) =>
      _parseIntConfig(config[_maxIdentifierLength]);

  static bool? parseCheckFunctionName(Map<String, Object> config) =>
      _parseBoolConfig(config[_checkFunctionName]);

  static bool? parseCheckClassName(Map<String, Object> config) =>
      _parseBoolConfig(config[_checkClassName]);

  static bool? parseCheckIdentifier(Map<String, Object> config) =>
      _parseBoolConfig(config[_checkIdentifierName]);

  static bool? _parseBoolConfig(Object? value) =>
      value == null ? null : value.toString().toLowerCase() == 'true';

  static int? _parseIntConfig(Object? value) =>
      value != null ? int.tryParse(value.toString()) : null;
}
