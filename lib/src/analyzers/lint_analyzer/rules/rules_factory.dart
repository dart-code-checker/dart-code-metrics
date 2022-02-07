import 'models/rule.dart';
import 'rules_list/always_remove_listener/always_remove_listener_rule.dart';
import 'rules_list/avoid_dynamic/avoid_dynamic_rule.dart';
import 'rules_list/avoid_global_state/avoid_global_state_rule.dart';
import 'rules_list/avoid_ignoring_return_values/avoid_ignoring_return_values_rule.dart';
import 'rules_list/avoid_late_keyword/avoid_late_keyword_rule.dart';
import 'rules_list/avoid_missing_enum_constant_in_map/avoid_missing_enum_constant_in_map_rule.dart';
import 'rules_list/avoid_nested_conditional_expressions/avoid_nested_conditional_expressions_rule.dart';
import 'rules_list/avoid_non_null_assertion/avoid_non_null_assertion_rule.dart';
import 'rules_list/avoid_preserve_whitespace_false/avoid_preserve_whitespace_false_rule.dart';
import 'rules_list/avoid_returning_widgets/avoid_returning_widgets_rule.dart';
import 'rules_list/avoid_throw_in_catch_block/avoid_throw_in_catch_block_rule.dart';
import 'rules_list/avoid_unnecessary_setstate/avoid_unnecessary_setstate_rule.dart';
import 'rules_list/avoid_unnecessary_type_assertions/avoid_unnecessary_type_assertions_rule.dart';
import 'rules_list/avoid_unnecessary_type_casts/avoid_unnecessary_type_casts_rule.dart';
import 'rules_list/avoid_unrelated_type_assertions/avoid_unrelated_type_assertions_rule.dart';
import 'rules_list/avoid_unused_parameters/avoid_unused_parameters_rule.dart';
import 'rules_list/avoid_wrapping_in_padding/avoid_wrapping_in_padding_rule.dart';
import 'rules_list/binary_expression_operand_order/binary_expression_operand_order_rule.dart';
import 'rules_list/component_annotation_arguments_ordering/component_annotation_arguments_ordering_rule.dart';
import 'rules_list/double_literal_format/double_literal_format_rule.dart';
import 'rules_list/member_ordering/member_ordering_rule.dart';
import 'rules_list/member_ordering_extended/member_ordering_extended_rule.dart';
import 'rules_list/newline_before_return/newline_before_return_rule.dart';
import 'rules_list/no_boolean_literal_compare/no_boolean_literal_compare_rule.dart';
import 'rules_list/no_empty_block/no_empty_block_rule.dart';
import 'rules_list/no_equal_arguments/no_equal_arguments_rule.dart';
import 'rules_list/no_equal_then_else/no_equal_then_else_rule.dart';
import 'rules_list/no_magic_number/no_magic_number_rule.dart';
import 'rules_list/no_object_declaration/no_object_declaration_rule.dart';
import 'rules_list/prefer_async_await/prefer_async_await_rule.dart';
import 'rules_list/prefer_conditional_expressions/prefer_conditional_expressions_rule.dart';
import 'rules_list/prefer_const_border_radius/prefer_const_border_radius_rule.dart';
import 'rules_list/prefer_correct_identifier_length/prefer_correct_identifier_length_rule.dart';
import 'rules_list/prefer_correct_type_name/prefer_correct_type_name_rule.dart';
import 'rules_list/prefer_extracting_callbacks/prefer_extracting_callbacks_rule.dart';
import 'rules_list/prefer_first/prefer_first_rule.dart';
import 'rules_list/prefer_intl_name/prefer_intl_name_rule.dart';
import 'rules_list/prefer_last/prefer_last_rule.dart';
import 'rules_list/prefer_match_file_name/prefer_match_file_name_rule.dart';
import 'rules_list/prefer_on_push_cd_strategy/prefer_on_push_cd_strategy_rule.dart';
import 'rules_list/prefer_single_widget_per_file/prefer_single_widget_per_file_rule.dart';
import 'rules_list/prefer_trailing_comma/prefer_trailing_comma_rule.dart';
import 'rules_list/provide_correct_intl_args/provide_correct_intl_args_rule.dart';

final _implementedRules = <String, Rule Function(Map<String, Object>)>{
  AlwaysRemoveListenerRule.ruleId: (config) => AlwaysRemoveListenerRule(config),
  AvoidDynamicRule.ruleId: (config) => AvoidDynamicRule(config),
  AvoidGlobalStateRule.ruleId: (config) => AvoidGlobalStateRule(config),
  AvoidIgnoringReturnValuesRule.ruleId: (config) =>
      AvoidIgnoringReturnValuesRule(config),
  AvoidLateKeywordRule.ruleId: (config) => AvoidLateKeywordRule(config),
  AvoidMissingEnumConstantInMapRule.ruleId: (config) =>
      AvoidMissingEnumConstantInMapRule(config),
  AvoidNestedConditionalExpressionsRule.ruleId: (config) =>
      AvoidNestedConditionalExpressionsRule(config),
  AvoidNonNullAssertionRule.ruleId: (config) =>
      AvoidNonNullAssertionRule(config),
  AvoidPreserveWhitespaceFalseRule.ruleId: (config) =>
      AvoidPreserveWhitespaceFalseRule(config),
  AvoidReturningWidgetsRule.ruleId: (config) =>
      AvoidReturningWidgetsRule(config),
  AvoidThrowInCatchBlockRule.ruleId: (config) =>
      AvoidThrowInCatchBlockRule(config),
  AvoidUnnecessarySetStateRule.ruleId: (config) =>
      AvoidUnnecessarySetStateRule(config),
  AvoidUnnecessaryTypeAssertionsRule.ruleId: (config) =>
      AvoidUnnecessaryTypeAssertionsRule(config),
  AvoidUnnecessaryTypeCastsRule.ruleId: (config) =>
      AvoidUnnecessaryTypeCastsRule(config),
  AvoidUnrelatedTypeAssertionsRule.ruleId: (config) =>
      AvoidUnrelatedTypeAssertionsRule(config),
  AvoidUnusedParametersRule.ruleId: (config) =>
      AvoidUnusedParametersRule(config),
  AvoidWrappingInPaddingRule.ruleId: (config) =>
      AvoidWrappingInPaddingRule(config),
  BinaryExpressionOperandOrderRule.ruleId: (config) =>
      BinaryExpressionOperandOrderRule(config),
  ComponentAnnotationArgumentsOrderingRule.ruleId: (config) =>
      ComponentAnnotationArgumentsOrderingRule(config),
  DoubleLiteralFormatRule.ruleId: (config) => DoubleLiteralFormatRule(config),
  MemberOrderingRule.ruleId: (config) => MemberOrderingRule(config),
  MemberOrderingExtendedRule.ruleId: (config) =>
      MemberOrderingExtendedRule(config),
  NewlineBeforeReturnRule.ruleId: (config) => NewlineBeforeReturnRule(config),
  NoBooleanLiteralCompareRule.ruleId: (config) =>
      NoBooleanLiteralCompareRule(config),
  NoEmptyBlockRule.ruleId: (config) => NoEmptyBlockRule(config),
  NoEqualArgumentsRule.ruleId: (config) => NoEqualArgumentsRule(config),
  NoEqualThenElseRule.ruleId: (config) => NoEqualThenElseRule(config),
  NoMagicNumberRule.ruleId: (config) => NoMagicNumberRule(config),
  NoObjectDeclarationRule.ruleId: (config) => NoObjectDeclarationRule(config),
  PreferAsyncAwaitRule.ruleId: (config) => PreferAsyncAwaitRule(config),
  PreferConditionalExpressionsRule.ruleId: (config) =>
      PreferConditionalExpressionsRule(config),
  PreferConstBorderRadiusRule.ruleId: (config) =>
      PreferConstBorderRadiusRule(config),
  PreferCorrectIdentifierLengthRule.ruleId: (config) =>
      PreferCorrectIdentifierLengthRule(config),
  PreferCorrectTypeNameRule.ruleId: (config) =>
      PreferCorrectTypeNameRule(config),
  PreferExtractingCallbacksRule.ruleId: (config) =>
      PreferExtractingCallbacksRule(config),
  PreferFirstRule.ruleId: (config) => PreferFirstRule(config),
  PreferIntlNameRule.ruleId: (config) => PreferIntlNameRule(config),
  PreferLastRule.ruleId: (config) => PreferLastRule(config),
  PreferMatchFileNameRule.ruleId: (config) => PreferMatchFileNameRule(config),
  PreferOnPushCdStrategyRule.ruleId: (config) =>
      PreferOnPushCdStrategyRule(config),
  PreferSingleWidgetPerFileRule.ruleId: (config) =>
      PreferSingleWidgetPerFileRule(config),
  PreferTrailingCommaRule.ruleId: (config) => PreferTrailingCommaRule(config),
  ProvideCorrectIntlArgsRule.ruleId: (config) =>
      ProvideCorrectIntlArgsRule(config),
};

Iterable<Rule> get allRules =>
    _implementedRules.keys.map((id) => _implementedRules[id]!({}));

Iterable<Rule> getRulesById(Map<String, Map<String, Object>> rulesConfig) =>
    List.unmodifiable(_implementedRules.keys
        .where((id) => rulesConfig.keys.contains(id))
        .map<Rule>((id) => _implementedRules[id]!(rulesConfig[id]!)));
