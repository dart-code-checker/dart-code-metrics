part of '../member_ordering_rule.dart';

class _Annotation {
  final String name;
  final String? publicName;

  static const override = _Annotation._('override', 'overridden');
  static const protected = _Annotation._('protected');
  static const unset = _Annotation._('unset');

  static const all = [
    override,
    protected,
    unset,
  ];

  const _Annotation._(this.name, [this.publicName]);

  static _Annotation parse(String? name) => all.firstWhere(
        (annotation) =>
            annotation.name == name ||
            (annotation.publicName != null && annotation.publicName == name),
        orElse: () => _Annotation.unset,
      );
}
