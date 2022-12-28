part of 'prefer_static_class_rule.dart';

class _ConfigParser {
  static const _ignorePrivate = 'ignore-private';
  static const _ignoreNames = 'ignore-names';
  static const _ignoreAnnotations = 'ignore-annotations';

  static const _defaultIgnoreNames = <String>[];
  static const _defaultIgnoreAnnotations = [
    ...functionalWidgetAnnotations,
    'riverpod',
  ];

  static bool parseIgnorePrivate(Map<String, Object> config) =>
      config[_ignorePrivate] as bool? ?? false;

  static Iterable<String> parseIgnoreNames(Map<String, Object> config) =>
      _parseIterable(config, _ignoreNames) ?? _defaultIgnoreNames;

  static Iterable<String> parseIgnoreAnnotations(Map<String, Object> config) =>
      _parseIterable(config, _ignoreAnnotations) ?? _defaultIgnoreAnnotations;

  static Iterable<String>? _parseIterable(
    Map<String, Object> config,
    String name,
  ) =>
      config[name] is Iterable
          ? List<String>.from(config[name] as Iterable)
          : null;
}
