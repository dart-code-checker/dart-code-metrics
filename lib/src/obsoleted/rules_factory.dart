// ignore_for_file: public_member_api_docs
import 'package:code_checker/rules.dart';

import 'rules/avoid_preserve_whitespace_false.dart';
import 'rules/avoid_unused_parameters.dart';
import 'rules/binary_expression_operand_order_rule.dart';
import 'rules/component_annotation_arguments_ordering.dart';
import 'rules/double_literal_format_rule.dart';
import 'rules/member_ordering.dart';
import 'rules/newline_before_return.dart';
import 'rules/no_boolean_literal_compare_rule.dart';
import 'rules/no_empty_block.dart';
import 'rules/no_equal_arguments.dart';
import 'rules/no_equal_then_else.dart';
import 'rules/no_magic_number_rule.dart';
import 'rules/no_object_declaration.dart';
import 'rules/potential_null_dereference.dart';
import 'rules/prefer_conditional_expressions.dart';
import 'rules/prefer_intl_name.dart';
import 'rules/prefer_on_push_cd_strategy.dart';
import 'rules/prefer_trailing_comma.dart';
import 'rules/prefer_trailing_comma_for_collection.dart';
import 'rules/provide_correct_intl_args.dart';

final _implementedRules = <String, Rule Function(Map<String, Object>)>{
  AvoidPreserveWhitespaceFalseRule.ruleId: (config) =>
      AvoidPreserveWhitespaceFalseRule(config: config),
  AvoidUnusedParameters.ruleId: (config) =>
      AvoidUnusedParameters(config: config),
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
  NoEqualArguments.ruleId: (config) => NoEqualArguments(config: config),
  NoEqualThenElse.ruleId: (config) => NoEqualThenElse(config: config),
  NoMagicNumberRule.ruleId: (config) => NoMagicNumberRule(config: config),
  NoObjectDeclarationRule.ruleId: (config) =>
      NoObjectDeclarationRule(config: config),
  PotentialNullDereference.ruleId: (config) =>
      PotentialNullDereference(config: config),
  PreferConditionalExpressions.ruleId: (config) =>
      PreferConditionalExpressions(config: config),
  PreferIntlNameRule.ruleId: (config) => PreferIntlNameRule(config: config),
  PreferOnPushCdStrategyRule.ruleId: (config) =>
      PreferOnPushCdStrategyRule(config: config),
  PreferTrailingComma.ruleId: (config) => PreferTrailingComma(config: config),
  PreferTrailingCommaForCollectionRule.ruleId: (config) =>
      PreferTrailingCommaForCollectionRule(config: config),
  ProvideCorrectIntlArgsRule.ruleId: (config) =>
      ProvideCorrectIntlArgsRule(config: config),
};

Iterable<Rule> get allRules =>
    _implementedRules.keys.map((id) => _implementedRules[id]({}));

Iterable<Rule> getRulesById(Map<String, Object> rulesConfig) =>
    List.unmodifiable(_implementedRules.keys
        .where((id) => rulesConfig.keys.contains(id))
        .map<Rule>((id) =>
            _implementedRules[id](rulesConfig[id] as Map<String, Object>)));
