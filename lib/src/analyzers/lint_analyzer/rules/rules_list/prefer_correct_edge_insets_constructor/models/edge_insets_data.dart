part of '../prefer_correct_edge_insets_constructor_rule.dart';

@immutable
class EdgeInsetsData {
  final String className;
  final String constructorName;
  final List<EdgeInsetsParam> params;

  const EdgeInsetsData(this.className, this.constructorName, this.params);
}
