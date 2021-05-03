part of '../member_ordering_extended_rule.dart';

@immutable
class _Annotation {
  final String name;

  static const override = _Annotation._('overridden');
  static const protected = _Annotation._('protected');
  static const unset = _Annotation._('unset');

  static const all = [
    override,
    protected,
    unset,
  ];

  const _Annotation._(this.name);

  static _Annotation parse(String name) => all.firstWhere(
        (annotation) => annotation.name == name,
        orElse: () => _Annotation.unset,
      );
}
