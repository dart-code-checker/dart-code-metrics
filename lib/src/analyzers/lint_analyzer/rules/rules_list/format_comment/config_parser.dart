part of 'format_comment_rule.dart';

class _ConfigParser {
  static const _ignoredPatternsConfig = 'ignored-patterns';
  static const _onlyDocComments = 'only-doc-comments';

  static Iterable<RegExp> parseIgnoredPatterns(Map<String, Object> config) =>
      config[_ignoredPatternsConfig] is Iterable
          ? List<String>.from(
              config[_ignoredPatternsConfig] as Iterable,
            ).map(RegExp.new)
          : const [];

  static bool parseOnlyDocComments(Map<String, Object> config) =>
      config[_onlyDocComments] == true;
}
