part of '../prefer_correct_type_name.dart';

const _defaultMinIdentifierLength = 3;
const _defaultMaxIdentifierLength = 40;
const _defaultExclude = <String>[];

const _minIdentifierLengthLabel = 'min-length';
const _maxIdentifierLengthLabel = 'max-length';
const _excludeLabel = 'excluded';

/// Parser for rule configuration
class _ConfigParser {
  /// Read min identifier length from config
  static int readMinIdentifierLength(Map<String, Object> config) =>
      _parseIntConfig(config[_minIdentifierLengthLabel]) ??
      _defaultMinIdentifierLength;

  /// Read max identifier length from config
  static int readMaxIdentifierLength(Map<String, Object> config) =>
      _parseIntConfig(config[_maxIdentifierLengthLabel]) ??
      _defaultMaxIdentifierLength;

  /// Read excludes list from config
  static Iterable<String> readExcludes(Map<String, Object> config) =>
      _isIterableOfStrings(config[_excludeLabel])
          ? (config[_excludeLabel] as Iterable).cast<String>()
          : _defaultExclude;

  static int? _parseIntConfig(Object? value) =>
      value != null ? int.tryParse(value.toString()) : null;

  static bool _isIterableOfStrings(Object? object) =>
      object is Iterable<Object> && object.every((node) => node is String);
}
