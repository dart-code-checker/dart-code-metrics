part of 'avoid_returning_widgets.dart';

class _ConfigParser {
  static const _ignoredNamesConfig = 'ignored-names';

  static Iterable<String> getIgnoredNames(Map<String, Object> config) =>
      config.containsKey(_ignoredNamesConfig) &&
              config[_ignoredNamesConfig] is Iterable
          ? List<String>.from(config[_ignoredNamesConfig] as Iterable)
          : <String>[];
}
