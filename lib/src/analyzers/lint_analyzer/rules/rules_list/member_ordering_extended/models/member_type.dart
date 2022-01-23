part of '../member_ordering_extended_rule.dart';

class _MemberType {
  final String type;

  static const field = _MemberType._('fields');
  static const method = _MemberType._('methods');
  static const constructor = _MemberType._('constructors');
  static const getter = _MemberType._('getters');
  static const setter = _MemberType._('setters');
  static const getterAndSetter = _MemberType._('getters-setters');

  static const all = [
    field,
    method,
    constructor,
    getter,
    setter,
    getterAndSetter,
  ];

  const _MemberType._(this.type);

  static _MemberType? parse(String? name) =>
      all.firstWhereOrNull((type) => name == type.type);
}
