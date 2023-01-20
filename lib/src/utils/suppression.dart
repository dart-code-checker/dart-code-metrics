import 'package:analyzer/source/line_info.dart';

/// Represents an information about rule suppression.
class Suppression {
  static final _ignoreMatchers = RegExp('//[ ]*ignore:(.*)', multiLine: true);

  static final _ignoreForFileMatcher =
      RegExp('//[ ]*ignore_for_file:(.*)', multiLine: true);

  static const _typeLint = 'type=lint';

  final _ignoreMap = <int, List<String>>{};
  final _ignoreForFileSet = <String>{};

  bool _hasAllLintsSuppressed = false;

  final LineInfo lineInfo;

  /// Checks that the [id] is globally suppressed.
  bool isSuppressed(String id) =>
      _hasAllLintsSuppressed || _ignoreForFileSet.contains(_canonicalize(id));

  /// Checks that the [id] is suppressed for the [lineIndex].
  bool isSuppressedAt(String id, int lineIndex) =>
      isSuppressed(id) ||
      (_ignoreMap[lineIndex]?.contains(_canonicalize(id)) ?? false);

  /// Initialize a newly created [Suppression] with the given [content] and [lineInfo].
  Suppression(
    String content,
    this.lineInfo, {
    bool supportsTypeLintIgnore = false,
  }) {
    for (final match in _ignoreMatchers.allMatches(content)) {
      final ids = match.group(1)!.split(',').map(_canonicalize);
      final location = lineInfo.getLocation(match.start);
      final lineNumber = location.lineNumber;
      final offset = lineInfo.getOffsetOfLine(lineNumber - 1);
      final beforeMatch =
          content.substring(offset, offset + location.columnNumber - 1);

      // If comment sits next to code, so it refers to its own line, otherwise it refers to the next line.
      final ignoredNextLine = beforeMatch.trim().isEmpty;
      _ignoreMap
          .putIfAbsent(
            ignoredNextLine ? lineNumber + 1 : lineNumber,
            () => <String>[],
          )
          .addAll(ids);
    }

    for (final match in _ignoreForFileMatcher.allMatches(content)) {
      final suppressed = match.group(1)!.split(',').map(_canonicalize);
      if (supportsTypeLintIgnore && suppressed.contains(_typeLint)) {
        _hasAllLintsSuppressed = true;
      } else {
        _ignoreForFileSet.addAll(suppressed);
      }
    }
  }

  String _canonicalize(String ruleId) => ruleId.trim().toLowerCase();
}
