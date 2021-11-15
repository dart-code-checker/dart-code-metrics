part of 'prefer_trailing_comma_rule.dart';

class _ConfigParser {
  static const _breakOnConfigName = 'break-on';
  static const _oldBreakOnConfigName = 'break_on';

  static int? parseBreakpoint(Map<String, Object> config) {
    final breakpoint = config.containsKey(_breakOnConfigName)
        ? config[_breakOnConfigName]
        : config[_oldBreakOnConfigName];

    return breakpoint != null ? int.tryParse(breakpoint.toString()) : null;
  }
}
