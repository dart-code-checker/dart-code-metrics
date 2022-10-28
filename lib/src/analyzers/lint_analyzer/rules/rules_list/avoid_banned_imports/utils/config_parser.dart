part of '../avoid_banned_imports_rule.dart';

const _entriesLabel = 'entries';
const _pathsLabel = 'paths';
const _denyLabel = 'deny';
const _messageLabel = 'message';

/// Parser for rule configuration.
class _ConfigParser {
  static List<_AvoidBannedImportsConfigEntry> _parseEntryConfig(
    Map<String, Object> config,
  ) =>
      (config[_entriesLabel] as Iterable<Object?>? ?? []).map((entry) {
        final entryMap = entry as Map<Object?, Object?>;

        return _AvoidBannedImportsConfigEntry(
          paths: _parseListRegExp(entryMap[_pathsLabel]),
          deny: _parseListRegExp(entryMap[_denyLabel]),
          message: entryMap[_messageLabel] as String,
        );
      }).toList();

  static List<RegExp> _parseListRegExp(Object? object) =>
      (object! as List<Object?>)
          .map((e) => e! as String)
          .map(RegExp.new)
          .toList();
}

class _AvoidBannedImportsConfigEntry {
  final List<RegExp> paths;
  final List<RegExp> deny;
  final String message;

  _AvoidBannedImportsConfigEntry({
    required this.paths,
    required this.deny,
    required this.message,
  });

  Map<String, Object?> toJson() => {
        'paths': paths.map((exp) => exp.pattern).toList(),
        'deny': deny.map((exp) => exp.pattern).toList(),
        'message': message,
      };
}
