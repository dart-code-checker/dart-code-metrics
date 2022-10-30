import 'models/severity.dart';

/// Returns a [Severity] from map based [config] otherwise [defaultValue]
Severity readSeverity(Map<String, Object?> config, Severity defaultValue) =>
    Severity.fromString(config['severity'] as String?) ?? defaultValue;

/// Returns a list of includes from the given [config]
Iterable<String> readIncludes(Map<String, Object> config) {
  final data = config['include'];

  return _isIterableOfStrings(data)
      ? (data as Iterable).cast<String>()
      : const <String>[];
}

bool hasIncludes(Map<String, Object> config) {
  final data = config['include'];

  return _isIterableOfStrings(data);
}

/// Returns a list of excludes from the given [config]
Iterable<String> readExcludes(Map<String, Object> config) {
  final data = config['exclude'];

  return _isIterableOfStrings(data)
      ? (data as Iterable).cast<String>()
      : const <String>[];
}

bool _isIterableOfStrings(Object? object) =>
    object is Iterable<Object> && object.every((node) => node is String);
