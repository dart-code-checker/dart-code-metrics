part of 'use_setstate_synchronously_rule.dart';

Set<String> readMethods(Map<String, Object> options) {
  final fromConfig = options['methods'];

  return fromConfig is List
      ? fromConfig.whereType<String>().toSet()
      : {'setState'};
}
