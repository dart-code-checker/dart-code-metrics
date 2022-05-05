part of 'format_comment_rule.dart';

class _ConfigParser {
  static const _ignoredPatternsConfig = 'ignored-patterns';

  static Iterable<RegExp> getIgnoredPatterns(Map<String, Object> config) =>
      config[_ignoredPatternsConfig] is Iterable
          ? List<String>.from(
              config[_ignoredPatternsConfig] as Iterable? ?? const <String>[],
            ).map((stringPattern) => RegExp(stringPattern))
          : const [];
}
