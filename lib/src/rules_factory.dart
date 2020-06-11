import 'rules/avoid_preserve_whitespace_false.dart';
import 'rules/base_rule.dart';
import 'rules/double_literal_format_rule.dart';
import 'rules/newline_before_return.dart';
import 'rules/no_boolean_literal_compare_rule.dart';
import 'rules/no_empty_block.dart';
import 'rules/prefer_trailing_commas.dart';

const _implementedRules = {
  AvoidPreserveWhitespaceFalseRule(),
  DoubleLiteralFormatRule(),
  NewlineBeforeReturnRule(),
  NoBooleanLiteralCompareRule(),
  NoEmptyBlockRule(),
  PreferTrailingCommasRule(),
};

Iterable<BaseRule> get allRules => _implementedRules;

Iterable<BaseRule> getRulesById(Iterable<String> rulesIdList) =>
    List.unmodifiable(allRules.where((rule) => rulesIdList.contains(rule.id)));
