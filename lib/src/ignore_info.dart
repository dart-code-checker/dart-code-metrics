import 'package:analyzer/source/line_info.dart';

class IgnoreInfo {
  static final _ignoreMatchers = RegExp('//[ ]*ignore:(.*)', multiLine: true);

  static final _ignoreForFileMatcher =
      RegExp('//[ ]*ignore_for_file:(.*)', multiLine: true);

  final _ignoreMap = <int, List<String>>{};
  final _ignoreForFileSet = <String>{};

  bool get hasIgnoreInfo =>
      _ignoreMap.isNotEmpty || _ignoreForFileSet.isNotEmpty;

  bool ignoreRule(String ruleId) =>
      _ignoreForFileSet.contains(canonicalize(ruleId));

  bool ignoredAt(String ruleId, int line) =>
      ignoreRule(canonicalize(ruleId)) ||
      (_ignoreMap[line]?.contains(canonicalize(ruleId)) ?? false);

  String canonicalize(String ruleId) => ruleId.trim().toLowerCase();

  IgnoreInfo.calculateIgnores(String content, LineInfo info) {
    for (final match in _ignoreMatchers.allMatches(content)) {
      final codes = match.group(1).split(',').map(canonicalize);
      final location = info.getLocation(match.start);
      final lineNumber = location.lineNumber;
      final beforeMatch = content.substring(
        info.getOffsetOfLine(lineNumber - 1),
        info.getOffsetOfLine(lineNumber - 1) + location.columnNumber - 1,
      );

      // If comment sits next to code, so it refers to its own line, otherwise it refers to the next line.
      final ignoredNextLine = beforeMatch.trim().isEmpty;
      _ignoreMap
          .putIfAbsent(
              ignoredNextLine ? lineNumber + 1 : lineNumber, () => <String>[])
          .addAll(codes);
    }

    for (final match in _ignoreForFileMatcher.allMatches(content)) {
      _ignoreForFileSet.addAll(match.group(1).split(',').map(canonicalize));
    }
  }
}
