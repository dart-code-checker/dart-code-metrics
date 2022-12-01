part of 'prefer_static_class_rule.dart';

class _ConfigParser {
  static const _ignorePrivate = 'ignore-private';
  static const _ignoreNames = 'ignore-names';
  static const _ignoreAnnotations = 'ignore-annotations';

  static const _defaultIgnorePrivate = false;
  static const _defaultIgnoreNames = <String>[];
  static const _defaultIgnoreAnnotations = [
    ...functionalWidgetAnnotations,
    'riverpod',
  ];

  static bool getIgnorePrivate(Map<String, Object> config) =>
      config[_ignorePrivate] as bool? ?? _defaultIgnorePrivate;

  static Iterable<String> getIgnoreNames(Map<String, Object> config) =>
      _getIterable(config, _ignoreNames) ?? _defaultIgnoreNames;

  static Iterable<String> getIgnoreAnnotations(Map<String, Object> config) =>
      _getIterable(config, _ignoreAnnotations) ?? _defaultIgnoreAnnotations;

  static Iterable<String>? _getIterable(
    Map<String, Object> config,
    String name,
  ) =>
      config[name] is Iterable
          ? List<String>.from(config[name] as Iterable)
          : null;
}
