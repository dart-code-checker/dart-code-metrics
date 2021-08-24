part of 'prefer_correct_identifier_length.dart';

class _ConfigParser {
  static const _minIdentifierLength = 'min-identifier-length';
  static const _maxIdentifierLength = 'max-identifier-length';

  static const _checkFunctionName = 'check-function-name';
  static const _checkGetters = 'check-getters-name';
  static const _checkSetters = 'check-setters-name';
  static const _checkClassName = 'check-class-name';
  static const _checkMethodName = 'check-method-name';
  static const _checkNamedConstructor = 'check-named-constructor-name';
  static const _checkIdentifierName = 'check-variable-name';
  static const _checkArgumentName = 'check-argument-name';

  //min-identifier-length
  static int? parseMinIdentifierLength(Map<String, Object> config) =>
      _parseIntConfig(config[_minIdentifierLength]);

  //max-identifier-length
  static int? parseMaxIdentifierLength(Map<String, Object> config) =>
      _parseIntConfig(config[_maxIdentifierLength]);

  //check-method-name
  static bool? parseCheckMethodName(Map<String, Object> config) =>
      _parseBoolConfig(config[_checkMethodName]);

  //check-function-name
  static bool? parseCheckFunctionName(Map<String, Object> config) =>
      _parseBoolConfig(config[_checkFunctionName]);

  //check-setters-name
  static bool? parseCheckSetters(Map<String, Object> config) =>
      _parseBoolConfig(config[_checkSetters]);

  //check-getters-name
  static bool? parseCheckGetters(Map<String, Object> config) =>
      _parseBoolConfig(config[_checkGetters]);

  //check-class-name
  static bool? parseCheckClassName(Map<String, Object> config) =>
      _parseBoolConfig(config[_checkClassName]);

  //check-named-constructor-name
  static bool? checkConstructorName(Map<String, Object> config) =>
      _parseBoolConfig(config[_checkNamedConstructor]);

  //check-variable-name
  static bool? parseCheckIdentifier(Map<String, Object> config) =>
      _parseBoolConfig(config[_checkIdentifierName]);

  //check-function-argument-name
  static bool? checkArgumentsName(Map<String, Object> config) =>
      _parseBoolConfig(config[_checkArgumentName]);

  static bool? _parseBoolConfig(Object? value) =>
      value == null ? null : value.toString().toLowerCase() == 'true';

  static int? _parseIntConfig(Object? value) =>
      value != null ? int.tryParse(value.toString()) : null;
}
