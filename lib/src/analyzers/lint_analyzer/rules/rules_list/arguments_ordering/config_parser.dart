part of 'arguments_ordering_rule.dart';

class _ConfigParser {
  static const _childLast = 'child-last';
  static const _childLastDefault = false;

  static bool parseChildLast(Map<String, Object> config) =>
      config[_childLast] as bool? ?? _childLastDefault;
}
