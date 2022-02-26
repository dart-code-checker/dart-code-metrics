part of '../tag_name_rule.dart';

const _varNamesLabel = 'var-names';

/// Parser for rule configuration.
class _ConfigParser {
  static _ParsedConfig _parseConfig(Map<String, Object> value) => _ParsedConfig(
        varNames: (value[_varNamesLabel] as List<Object>? ?? <Object>[])
            .map((item) => item as String)
            .toList(),
      );
}

class _ParsedConfig {
  final List<String> varNames;

  _ParsedConfig({required this.varNames});
}
