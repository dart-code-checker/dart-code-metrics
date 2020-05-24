import 'rules/base_rule.dart';
import 'rules/double_literal_format_rule.dart';

const _implementedRules = {
  DoubleLiteralFormatRule(),
};

Iterable<BaseRule> get allRules => _implementedRules;

Iterable<BaseRule> getRulesById(Iterable<String> rulesIdList) =>
    List.unmodifiable(allRules.where((rule) => rulesIdList.contains(rule.id)));
