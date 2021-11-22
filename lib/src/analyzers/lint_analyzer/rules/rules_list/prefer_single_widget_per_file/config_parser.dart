part of 'prefer_single_widget_per_file_rule.dart';

class _ConfigParser {
  static const _ignorePrivateWidgetsName = 'ignore-private-widgets';

  static bool parseIgnorePrivateWidgets(Map<String, Object> config) =>
      config[_ignorePrivateWidgetsName] == true;
}
