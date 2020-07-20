import 'rules/avoid_preserve_whitespace_false.dart';
import 'rules/base_rule.dart';
import 'rules/binary_expression_operand_order_rule.dart';
import 'rules/double_literal_format_rule.dart';
import 'rules/newline_before_return.dart';
import 'rules/no_boolean_literal_compare_rule.dart';
import 'rules/no_empty_block.dart';
import 'rules/no_magic_number_rule.dart';
import 'rules/no_object_declaration.dart';
import 'rules/prefer_conditional_expressions.dart';
import 'rules/prefer_intl_name.dart';
import 'rules/prefer_trailing_comma_for_collection.dart';

const _implementedRules = {
  AvoidPreserveWhitespaceFalseRule(),
  BinaryExpressionOperandOrderRule(),
  DoubleLiteralFormatRule(),
  NewlineBeforeReturnRule(),
  NoBooleanLiteralCompareRule(),
  NoEmptyBlockRule(),
  NoMagicNumberRule(),
  NoObjectDeclarationRule(),
  PreferConditionalExpressions(),
  PreferIntlNameRule(),
  PreferTrailingCommaForCollectionRule(),
};

Iterable<BaseRule> get allRules => _implementedRules;

Iterable<BaseRule> getRulesById(Iterable<String> rulesIdList) =>
    List.unmodifiable(allRules.where((rule) => rulesIdList.contains(rule.id)));
