part of 'avoid_returning_widgets.dart';

class _ConfigParser {
  static const _ignoredNamesConfig = 'ignored-names';
  static const _ignoredAnnotationsConfig = 'ignored-annotations';

  static Iterable<String> getIgnoredNames(Map<String, Object> config) =>
      _getIterable(config, _ignoredNamesConfig);

  static Iterable<String> getIgnoredAnnotations(Map<String, Object> config) =>
      _getIterable(config, _ignoredAnnotationsConfig);

  static Iterable<String> _getIterable(
    Map<String, Object> config,
    String name,
  ) =>
      config.containsKey(name) && config[name] is Iterable
          ? List<String>.from(config[name] as Iterable)
          : <String>[];
}
