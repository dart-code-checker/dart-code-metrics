part of 'use_setstate_synchronously_rule.dart';

Set<String> readMethods(Map<String, Object> options) {
  final methods = options['methods'];

  return methods != null && methods is Iterable
      ? methods.whereType<String>().toSet()
      : {'setState'};
}
