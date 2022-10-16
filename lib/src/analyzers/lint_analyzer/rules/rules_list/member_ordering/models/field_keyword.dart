part of '../member_ordering_rule.dart';

class _FieldKeyword {
  final String type;

  static const isFinal = _FieldKeyword('final');
  static const isConst = _FieldKeyword('const');
  static const isVar = _FieldKeyword('var');
  static const unset = _FieldKeyword('unset');

  static const all = [
    isFinal,
    isConst,
    isVar,
    unset,
  ];

  const _FieldKeyword(this.type);

  static _FieldKeyword parse(String? name) => all.firstWhere(
        (type) => type.type == name,
        orElse: () => _FieldKeyword.unset,
      );
}
