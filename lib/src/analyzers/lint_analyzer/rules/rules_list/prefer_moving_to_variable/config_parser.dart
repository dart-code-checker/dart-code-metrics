part of 'prefer_moving_to_variable_rule.dart';

class _ConfigParser {
  static const _allowedDuplicatedChains = 'allowed-duplicated-chains';

  static int? parseAllowedDuplicatedChains(Map<String, Object> config) {
    final raw = config[_allowedDuplicatedChains];

    return raw is int? ? raw : null;
  }
}
