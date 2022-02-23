part of '../prefer_correct_type_name_rule.dart';

const _defaultMinTypeLength = 3;
const _defaultMaxTypeLength = 40;
const _defaultExclude = <String>[];

const _minTypeLengthLabel = 'min-length';
const _maxTypeLengthLabel = 'max-length';
const _excludeLabel = 'excluded';

/// Parser for rule configuration.
class _ConfigParser {
  /// Read min type length from config.
  static int readMinTypeLength(Map<String, Object> config) =>
      _parseIntConfig(config[_minTypeLengthLabel]) ?? _defaultMinTypeLength;

  /// Read max type length from config.
  static int readMaxTypeLength(Map<String, Object> config) =>
      _parseIntConfig(config[_maxTypeLengthLabel]) ?? _defaultMaxTypeLength;

  /// Read excludes list from config.
  static Iterable<String> readExcludes(Map<String, Object> config) =>
      _isIterableOfStrings(config[_excludeLabel])
          ? (config[_excludeLabel] as Iterable).cast<String>()
          : _defaultExclude;

  static int? _parseIntConfig(Object? value) =>
      value != null ? int.tryParse(value.toString()) : null;

  static bool _isIterableOfStrings(Object? object) =>
      object is Iterable<Object> && object.every((node) => node is String);
}
