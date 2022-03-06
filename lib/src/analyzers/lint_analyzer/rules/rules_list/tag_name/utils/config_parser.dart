part of '../tag_name_rule.dart';

const _varNamesLabel = 'var-names';
const _stripPrefixLabel = 'strip-prefix';
const _stripPostfixLabel = 'strip-postfix';

/// Parser for rule configuration.
class _ConfigParser {
  static _ParsedConfig _parseConfig(Map<String, Object> value) => _ParsedConfig(
        varNames: (value[_varNamesLabel] as List<Object>? ?? <Object>[])
            .map((item) => item as String)
            .toList(),
        stripPrefix: value[_stripPrefixLabel] as String? ?? '',
        stripPostfix: value[_stripPostfixLabel] as String? ?? '',
      );
}

class _ParsedConfig {
  final List<String> varNames;
  final String stripPrefix;
  final String stripPostfix;

  _ParsedConfig({
    required this.varNames,
    required this.stripPrefix,
    required this.stripPostfix,
  });
}
