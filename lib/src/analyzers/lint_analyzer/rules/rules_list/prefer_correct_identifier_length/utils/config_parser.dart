part of '../prefer_correct_identifier_length_rule.dart';

const _defaultMinIdentifierLength = 3;
const _defaultMaxIdentifierLength = 300;
const _defaultExceptions = <String>[];

const _minIdentifierLengthLabel = 'min-identifier-length';
const _maxIdentifierLengthLabel = 'max-identifier-length';
const _exceptionsLabel = 'exceptions';

/// Parser for rule configuration.
class _ConfigParser {
  /// Read min identifier length from config.
  static int readMinIdentifierLength(Map<String, Object> config) =>
      _parseIntConfig(config[_minIdentifierLengthLabel]) ??
      _defaultMinIdentifierLength;

  /// Read max identifier length from config.
  static int readMaxIdentifierLength(Map<String, Object> config) =>
      _parseIntConfig(config[_maxIdentifierLengthLabel]) ??
      _defaultMaxIdentifierLength;

  /// Read exceptions list from config.
  static Iterable<String> readExceptions(Map<String, Object> config) =>
      _isIterableOfStrings(config[_exceptionsLabel])
          ? (config[_exceptionsLabel] as Iterable).cast<String>()
          : _defaultExceptions;

  static int? _parseIntConfig(Object? value) =>
      value != null ? int.tryParse(value.toString()) : null;

  static bool _isIterableOfStrings(Object? object) =>
      object is Iterable<Object> && object.every((node) => node is String);
}
