import 'models/rule.dart';
import 'rules_list/avoid_late_keyword.dart';
import 'rules_list/avoid_non_null_assertion_rule.dart';
import 'rules_list/avoid_preserve_whitespace_false.dart';
import 'rules_list/avoid_returning_widgets_rule.dart';
import 'rules_list/avoid_unused_parameters.dart';
import 'rules_list/binary_expression_operand_order_rule.dart';
import 'rules_list/component_annotation_arguments_ordering.dart';
import 'rules_list/double_literal_format/double_literal_format.dart';
import 'rules_list/member_ordering.dart';
import 'rules_list/member_ordering_extended/member_ordering_extended_rule.dart';
import 'rules_list/newline_before_return/newline_before_return.dart';
import 'rules_list/no_boolean_literal_compare_rule.dart';
import 'rules_list/no_empty_block.dart';
import 'rules_list/no_equal_arguments.dart';
import 'rules_list/no_equal_then_else.dart';
import 'rules_list/no_magic_number_rule.dart';
import 'rules_list/no_object_declaration.dart';
import 'rules_list/prefer_conditional_expressions.dart';
import 'rules_list/prefer_intl_name.dart';
import 'rules_list/prefer_on_push_cd_strategy.dart';
import 'rules_list/prefer_trailing_comma.dart';
import 'rules_list/provide_correct_intl_args.dart';

final _implementedRules = <String, Rule Function(Map<String, Object>)>{
  AvoidLateKeywordRule.ruleId: (config) => AvoidLateKeywordRule(config: config),
  AvoidNonNullAssertionRule.ruleId: (config) =>
      AvoidNonNullAssertionRule(config: config),
  AvoidPreserveWhitespaceFalseRule.ruleId: (config) =>
      AvoidPreserveWhitespaceFalseRule(config: config),
  AvoidReturningWidgets.ruleId: (config) =>
      AvoidReturningWidgets(config: config),
  AvoidUnusedParameters.ruleId: (config) =>
      AvoidUnusedParameters(config: config),
  BinaryExpressionOperandOrderRule.ruleId: (config) =>
      BinaryExpressionOperandOrderRule(config: config),
  ComponentAnnotationArgumentsOrderingRule.ruleId: (config) =>
      ComponentAnnotationArgumentsOrderingRule(config: config),
  DoubleLiteralFormatRule.ruleId: (config) =>
      DoubleLiteralFormatRule(config: config),
  MemberOrderingRule.ruleId: (config) => MemberOrderingRule(config: config),
  MemberOrderingExtendedRule.ruleId: (config) =>
      MemberOrderingExtendedRule(config: config),
  NewlineBeforeReturnRule.ruleId: (config) =>
      NewlineBeforeReturnRule(config: config),
  NoBooleanLiteralCompareRule.ruleId: (config) =>
      NoBooleanLiteralCompareRule(config: config),
  NoEmptyBlockRule.ruleId: (config) => NoEmptyBlockRule(config: config),
  NoEqualArguments.ruleId: (config) => NoEqualArguments(config: config),
  NoEqualThenElse.ruleId: (config) => NoEqualThenElse(config: config),
  NoMagicNumberRule.ruleId: (config) => NoMagicNumberRule(config: config),
  NoObjectDeclarationRule.ruleId: (config) =>
      NoObjectDeclarationRule(config: config),
  PreferConditionalExpressions.ruleId: (config) =>
      PreferConditionalExpressions(config: config),
  PreferIntlNameRule.ruleId: (config) => PreferIntlNameRule(config: config),
  PreferOnPushCdStrategyRule.ruleId: (config) =>
      PreferOnPushCdStrategyRule(config: config),
  PreferTrailingComma.ruleId: (config) => PreferTrailingComma(config: config),
  ProvideCorrectIntlArgsRule.ruleId: (config) =>
      ProvideCorrectIntlArgsRule(config: config),
};

Iterable<Rule> get allRules =>
    _implementedRules.keys.map((id) => _implementedRules[id]!({}));

Iterable<Rule> getRulesById(Map<String, Map<String, Object>> rulesConfig) =>
    List.unmodifiable(_implementedRules.keys
        .where((id) => rulesConfig.keys.contains(id))
        .map<Rule>((id) => _implementedRules[id]!(rulesConfig[id]!)));
