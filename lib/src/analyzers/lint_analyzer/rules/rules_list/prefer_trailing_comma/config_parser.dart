part of 'prefer_trailing_comma.dart';

class _ConfigParser {
  static const _breakOnConfigName = 'allowed';

  static int? parseBreakpoint(Map<String, Object> config) {
    final breakpoint = config.containsKey(_breakOnConfigName)
        ? config[_breakOnConfigName]
        : config[_breakOnConfigName];

    return breakpoint != null ? int.tryParse(breakpoint.toString()) : null;
  }
}
