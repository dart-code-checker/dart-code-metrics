import 'models/rule.dart';
import 'rules_list/always_remove_listener/always_remove_listener.dart';
import 'rules_list/avoid_ignoring_return_values/avoid_ignoring_return_values.dart';
import 'rules_list/avoid_late_keyword/avoid_late_keyword.dart';
import 'rules_list/avoid_non_null_assertion/avoid_non_null_assertion.dart';
import 'rules_list/avoid_preserve_whitespace_false/avoid_preserve_whitespace_false.dart';
import 'rules_list/avoid_returning_widgets/avoid_returning_widgets.dart';
import 'rules_list/avoid_unnecessary_setstate/avoid_unnecessary_setstate.dart';
import 'rules_list/avoid_unused_parameters/avoid_unused_parameters.dart';
import 'rules_list/avoid_wrapping_in_padding/avoid_wrapping_in_padding.dart';
import 'rules_list/binary_expression_operand_order/binary_expression_operand_order.dart';
import 'rules_list/component_annotation_arguments_ordering/component_annotation_arguments_ordering.dart';
import 'rules_list/double_literal_format/double_literal_format.dart';
import 'rules_list/member_ordering/member_ordering.dart';
import 'rules_list/member_ordering_extended/member_ordering_extended.dart';
import 'rules_list/newline_before_return/newline_before_return.dart';
import 'rules_list/no_boolean_literal_compare/no_boolean_literal_compare.dart';
import 'rules_list/no_empty_block/no_empty_block.dart';
import 'rules_list/no_equal_arguments/no_equal_arguments.dart';
import 'rules_list/no_equal_then_else/no_equal_then_else.dart';
import 'rules_list/no_magic_number/no_magic_number.dart';
import 'rules_list/no_object_declaration/no_object_declaration.dart';
import 'rules_list/prefer_conditional_expressions/prefer_conditional_expressions.dart';
import 'rules_list/prefer_const_border_radius/prefer_const_border_radius.dart';
import 'rules_list/prefer_correct_identifier_length/prefer_correct_identifier_length.dart';
import 'rules_list/prefer_correct_type_name/prefer_correct_type_name.dart';
import 'rules_list/prefer_extracting_callbacks/prefer_extracting_callbacks.dart';
import 'rules_list/prefer_first/prefer_first.dart';
import 'rules_list/prefer_intl_name/prefer_intl_name.dart';
import 'rules_list/prefer_last/prefer_last.dart';
import 'rules_list/prefer_match_file_name/prefer_match_file_name.dart';
import 'rules_list/prefer_on_push_cd_strategy/prefer_on_push_cd_strategy.dart';
import 'rules_list/prefer_single_widget_per_file/prefer_single_widget_per_file.dart';
import 'rules_list/prefer_trailing_comma/prefer_trailing_comma.dart';
import 'rules_list/provide_correct_intl_args/provide_correct_intl_args.dart';

final _implementedRules = <String, Rule Function(Map<String, Object>)>{
  AlwaysRemoveListenerRule.ruleId: (config) => AlwaysRemoveListenerRule(config),
  AvoidIgnoringReturnValuesRule.ruleId: (config) =>
      AvoidIgnoringReturnValuesRule(config),
  AvoidLateKeywordRule.ruleId: (config) => AvoidLateKeywordRule(config),
  AvoidNonNullAssertionRule.ruleId: (config) =>
      AvoidNonNullAssertionRule(config),
  AvoidPreserveWhitespaceFalseRule.ruleId: (config) =>
      AvoidPreserveWhitespaceFalseRule(config),
  AvoidReturningWidgetsRule.ruleId: (config) =>
      AvoidReturningWidgetsRule(config),
  AvoidUnnecessarySetStateRule.ruleId: (config) =>
      AvoidUnnecessarySetStateRule(config),
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
  PreferConditionalExpressionsRule.ruleId: (config) =>
      PreferConditionalExpressionsRule(config),
  PreferConstBorderRadiusRule.ruleId: (config) =>
      PreferConstBorderRadiusRule(config),
  PreferCorrectIdentifierLength.ruleId: (config) =>
      PreferCorrectIdentifierLength(config),
  PreferCorrectTypeName.ruleId: (config) => PreferCorrectTypeName(config),
  PreferExtractingCallbacksRule.ruleId: (config) =>
      PreferExtractingCallbacksRule(config),
  PreferFirstRule.ruleId: (config) => PreferFirstRule(config),
  PreferIntlNameRule.ruleId: (config) => PreferIntlNameRule(config),
  PreferLastRule.ruleId: (config) => PreferLastRule(config),
  PreferMatchFileName.ruleId: (config) => PreferMatchFileName(config),
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
