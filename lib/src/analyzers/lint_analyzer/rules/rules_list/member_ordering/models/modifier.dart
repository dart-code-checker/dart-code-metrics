part of '../member_ordering_rule.dart';

class _Modifier {
  final String type;

  const _Modifier(this.type);

  static const public = _Modifier('public');
  static const private = _Modifier('private');
  static const unset = _Modifier('unset');

  static const all = [
    public,
    private,
    unset,
  ];

  static _Modifier parse(String? name) => all
      .firstWhere((type) => type.type == name, orElse: () => _Modifier.unset);
}
