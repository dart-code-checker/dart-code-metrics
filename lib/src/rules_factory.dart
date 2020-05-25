import 'rules/base_rule.dart';
import 'rules/double_literal_format_rule.dart';
import 'rules/no_boolean_literal_compare_rule.dart';

const _implementedRules = {
  DoubleLiteralFormatRule(),
  NoBooleanLiteralCompareRule(),
};

Iterable<BaseRule> get allRules => _implementedRules;

Iterable<BaseRule> getRulesById(Iterable<String> rulesIdList) =>
    List.unmodifiable(allRules.where((rule) => rulesIdList.contains(rule.id)));
