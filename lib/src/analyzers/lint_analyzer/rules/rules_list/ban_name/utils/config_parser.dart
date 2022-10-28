part of '../ban_name_rule.dart';

const _entriesLabel = 'entries';
const _identLabel = 'ident';
const _descriptionLabel = 'description';

/// Parser for rule configuration.
class _ConfigParser {
  static List<_BanNameConfigEntry> _parseEntryConfig(
    Map<String, Object> config,
  ) =>
      (config[_entriesLabel] as Iterable<Object?>? ?? []).map((entry) {
        final entryMap = entry as Map<Object?, Object?>;

        return _BanNameConfigEntry(
          ident: entryMap[_identLabel] as String,
          description: entryMap[_descriptionLabel] as String,
        );
      }).toList();
}

class _BanNameConfigEntry {
  final String ident;
  final String description;

  _BanNameConfigEntry({required this.ident, required this.description});

  Map<String, Object?> toJson() => {
        'identifier': ident,
        'description': description,
      };
}
