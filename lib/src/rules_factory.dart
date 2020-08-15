import 'rules/avoid_preserve_whitespace_false.dart';
import 'rules/base_rule.dart';
import 'rules/binary_expression_operand_order_rule.dart';
import 'rules/component_annotation_arguments_ordering.dart';
import 'rules/double_literal_format_rule.dart';
import 'rules/member_ordering.dart';
import 'rules/newline_before_return.dart';
import 'rules/no_boolean_literal_compare_rule.dart';
import 'rules/no_empty_block.dart';
import 'rules/no_magic_number_rule.dart';
import 'rules/no_object_declaration.dart';
import 'rules/prefer_conditional_expressions.dart';
import 'rules/prefer_intl_name.dart';
import 'rules/prefer_on_push_cd_strategy.dart';
import 'rules/prefer_trailing_comma_for_collection.dart';

final _implementedRules = <String, BaseRule Function(Map<String, Object>)>{
  AvoidPreserveWhitespaceFalseRule.ruleId: (config) =>
      AvoidPreserveWhitespaceFalseRule(config: config),
  BinaryExpressionOperandOrderRule.ruleId: (config) =>
      BinaryExpressionOperandOrderRule(config: config),
  ComponentAnnotationArgumentsOrderingRule.ruleId: (config) =>
      ComponentAnnotationArgumentsOrderingRule(config: config),
  DoubleLiteralFormatRule.ruleId: (config) =>
      DoubleLiteralFormatRule(config: config),
  MemberOrderingRule.ruleId: (config) => MemberOrderingRule(config: config),
  NewlineBeforeReturnRule.ruleId: (config) =>
      NewlineBeforeReturnRule(config: config),
  NoBooleanLiteralCompareRule.ruleId: (config) =>
      NoBooleanLiteralCompareRule(config: config),
  NoEmptyBlockRule.ruleId: (config) => NoEmptyBlockRule(config: config),
  NoMagicNumberRule.ruleId: (config) => NoMagicNumberRule(config: config),
  NoObjectDeclarationRule.ruleId: (config) =>
      NoObjectDeclarationRule(config: config),
  PreferConditionalExpressions.ruleId: (config) =>
      PreferConditionalExpressions(config: config),
  PreferIntlNameRule.ruleId: (config) => PreferIntlNameRule(config: config),
  PreferTrailingCommaForCollectionRule.ruleId: (config) =>
      PreferTrailingCommaForCollectionRule(config: config),
  PreferOnPushCdStrategyRule.ruleId: (config) =>
      PreferOnPushCdStrategyRule(config: config),
};

Iterable<BaseRule> get allRules =>
    _implementedRules.keys.map((id) => _implementedRules[id]({}));

Iterable<BaseRule> getRulesById(Map<String, Object> rulesConfig) =>
    List.unmodifiable(_implementedRules.keys
        .where((id) => rulesConfig.keys.contains(id))
        .map<BaseRule>((id) =>
            _implementedRules[id](rulesConfig[id] as Map<String, Object>)));
