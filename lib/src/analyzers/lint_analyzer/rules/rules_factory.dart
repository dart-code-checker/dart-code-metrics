import 'models/rule.dart';
import 'rules_list/always_remove_listener/always_remove_listener_rule.dart';
import 'rules_list/arguments_ordering/arguments_ordering_rule.dart';
import 'rules_list/avoid_banned_imports/avoid_banned_imports_rule.dart';
import 'rules_list/avoid_border_all/avoid_border_all_rule.dart';
import 'rules_list/avoid_cascade_after_if_null/avoid_cascade_after_if_null_rule.dart';
import 'rules_list/avoid_collection_methods_with_unrelated_types/avoid_collection_methods_with_unrelated_types_rule.dart';
import 'rules_list/avoid_creating_vector_in_update/avoid_creating_vector_in_update_rule.dart';
import 'rules_list/avoid_double_slash_imports/avoid_double_slash_imports_rule.dart';
import 'rules_list/avoid_duplicate_exports/avoid_duplicate_exports_rule.dart';
import 'rules_list/avoid_dynamic/avoid_dynamic_rule.dart';
import 'rules_list/avoid_expanded_as_spacer/avoid_expanded_as_spacer_rule.dart';
import 'rules_list/avoid_global_state/avoid_global_state_rule.dart';
import 'rules_list/avoid_ignoring_return_values/avoid_ignoring_return_values_rule.dart';
import 'rules_list/avoid_initializing_in_on_mount/avoid_initializing_in_on_mount_rule.dart';
import 'rules_list/avoid_late_keyword/avoid_late_keyword_rule.dart';
import 'rules_list/avoid_missing_enum_constant_in_map/avoid_missing_enum_constant_in_map_rule.dart';
import 'rules_list/avoid_nested_conditional_expressions/avoid_nested_conditional_expressions_rule.dart';
import 'rules_list/avoid_non_ascii_symbols/avoid_non_ascii_symbols_rule.dart';
import 'rules_list/avoid_non_null_assertion/avoid_non_null_assertion_rule.dart';
import 'rules_list/avoid_passing_async_when_sync_expected/avoid_passing_async_when_sync_expected_rule.dart';
import 'rules_list/avoid_preserve_whitespace_false/avoid_preserve_whitespace_false_rule.dart';
import 'rules_list/avoid_redundant_async/avoid_redundant_async_rule.dart';
import 'rules_list/avoid_redundant_async_on_load/avoid_redundant_async_on_load_rule.dart';
import 'rules_list/avoid_returning_widgets/avoid_returning_widgets_rule.dart';
import 'rules_list/avoid_shrink_wrap_in_lists/avoid_shrink_wrap_in_lists_rule.dart';
import 'rules_list/avoid_substring/avoid_substring_rule.dart';
import 'rules_list/avoid_throw_in_catch_block/avoid_throw_in_catch_block_rule.dart';
import 'rules_list/avoid_top_level_members_in_tests/avoid_top_level_members_in_tests_rule.dart';
import 'rules_list/avoid_unnecessary_conditionals/avoid_unnecessary_conditionals_rule.dart';
import 'rules_list/avoid_unnecessary_setstate/avoid_unnecessary_setstate_rule.dart';
import 'rules_list/avoid_unnecessary_type_assertions/avoid_unnecessary_type_assertions_rule.dart';
import 'rules_list/avoid_unnecessary_type_casts/avoid_unnecessary_type_casts_rule.dart';
import 'rules_list/avoid_unrelated_type_assertions/avoid_unrelated_type_assertions_rule.dart';
import 'rules_list/avoid_unused_parameters/avoid_unused_parameters_rule.dart';
import 'rules_list/avoid_wrapping_in_padding/avoid_wrapping_in_padding_rule.dart';
import 'rules_list/ban_name/ban_name_rule.dart';
import 'rules_list/binary_expression_operand_order/binary_expression_operand_order_rule.dart';
import 'rules_list/check_for_equals_in_render_object_setters/check_for_equals_in_render_object_setters_rule.dart';
import 'rules_list/component_annotation_arguments_ordering/component_annotation_arguments_ordering_rule.dart';
import 'rules_list/consistent_update_render_object/consistent_update_render_object_rule.dart';
import 'rules_list/correct_game_instantiating/correct_game_instantiating_rule.dart';
import 'rules_list/double_literal_format/double_literal_format_rule.dart';
import 'rules_list/format_comment/format_comment_rule.dart';
import 'rules_list/list_all_equatable_fields/list_all_equatable_fields_rule.dart';
import 'rules_list/member_ordering/member_ordering_rule.dart';
import 'rules_list/missing_test_assertion/missing_test_assertion_rule.dart';
import 'rules_list/newline_before_return/newline_before_return_rule.dart';
import 'rules_list/no_boolean_literal_compare/no_boolean_literal_compare_rule.dart';
import 'rules_list/no_empty_block/no_empty_block_rule.dart';
import 'rules_list/no_equal_arguments/no_equal_arguments_rule.dart';
import 'rules_list/no_equal_then_else/no_equal_then_else_rule.dart';
import 'rules_list/no_magic_number/no_magic_number_rule.dart';
import 'rules_list/no_object_declaration/no_object_declaration_rule.dart';
import 'rules_list/prefer_async_await/prefer_async_await_rule.dart';
import 'rules_list/prefer_commenting_analyzer_ignores/prefer_commenting_analyzer_ignores.dart';
import 'rules_list/prefer_conditional_expressions/prefer_conditional_expressions_rule.dart';
import 'rules_list/prefer_const_border_radius/prefer_const_border_radius_rule.dart';
import 'rules_list/prefer_correct_edge_insets_constructor/prefer_correct_edge_insets_constructor_rule.dart';
import 'rules_list/prefer_correct_identifier_length/prefer_correct_identifier_length_rule.dart';
import 'rules_list/prefer_correct_test_file_name/prefer_correct_test_file_name_rule.dart';
import 'rules_list/prefer_correct_type_name/prefer_correct_type_name_rule.dart';
import 'rules_list/prefer_define_hero_tag/prefer_define_hero_tag_rule.dart';
import 'rules_list/prefer_enums_by_name/prefer_enums_by_name_rule.dart';
import 'rules_list/prefer_extracting_callbacks/prefer_extracting_callbacks_rule.dart';
import 'rules_list/prefer_first/prefer_first_rule.dart';
import 'rules_list/prefer_immediate_return/prefer_immediate_return_rule.dart';
import 'rules_list/prefer_intl_name/prefer_intl_name_rule.dart';
import 'rules_list/prefer_iterable_of/prefer_iterable_of_rule.dart';
import 'rules_list/prefer_last/prefer_last_rule.dart';
import 'rules_list/prefer_match_file_name/prefer_match_file_name_rule.dart';
import 'rules_list/prefer_moving_to_variable/prefer_moving_to_variable_rule.dart';
import 'rules_list/prefer_on_push_cd_strategy/prefer_on_push_cd_strategy_rule.dart';
import 'rules_list/prefer_provide_intl_description/prefer_provide_intl_description_rule.dart';
import 'rules_list/prefer_single_widget_per_file/prefer_single_widget_per_file_rule.dart';
import 'rules_list/prefer_static_class/prefer_static_class_rule.dart';
import 'rules_list/prefer_trailing_comma/prefer_trailing_comma_rule.dart';
import 'rules_list/prefer_using_list_view/prefer_using_list_view_rule.dart';
import 'rules_list/provide_correct_intl_args/provide_correct_intl_args_rule.dart';
import 'rules_list/tag_name/tag_name_rule.dart';
import 'rules_list/use_setstate_synchronously/use_setstate_synchronously_rule.dart';

final _implementedRules = <String, Rule Function(Map<String, Object>)>{
  AlwaysRemoveListenerRule.ruleId: AlwaysRemoveListenerRule.new,
  ArgumentsOrderingRule.ruleId: ArgumentsOrderingRule.new,
  AvoidBannedImportsRule.ruleId: AvoidBannedImportsRule.new,
  AvoidBorderAllRule.ruleId: AvoidBorderAllRule.new,
  AvoidCascadeAfterIfNullRule.ruleId: AvoidCascadeAfterIfNullRule.new,
  AvoidCollectionMethodsWithUnrelatedTypesRule.ruleId:
      AvoidCollectionMethodsWithUnrelatedTypesRule.new,
  AvoidCreatingVectorInUpdateRule.ruleId: AvoidCreatingVectorInUpdateRule.new,
  AvoidDoubleSlashImportsRule.ruleId: AvoidDoubleSlashImportsRule.new,
  AvoidDuplicateExportsRule.ruleId: AvoidDuplicateExportsRule.new,
  AvoidDynamicRule.ruleId: AvoidDynamicRule.new,
  AvoidGlobalStateRule.ruleId: AvoidGlobalStateRule.new,
  AvoidIgnoringReturnValuesRule.ruleId: AvoidIgnoringReturnValuesRule.new,
  AvoidInitializingInOnMountRule.ruleId: AvoidInitializingInOnMountRule.new,
  AvoidLateKeywordRule.ruleId: AvoidLateKeywordRule.new,
  AvoidMissingEnumConstantInMapRule.ruleId:
      AvoidMissingEnumConstantInMapRule.new,
  AvoidNestedConditionalExpressionsRule.ruleId:
      AvoidNestedConditionalExpressionsRule.new,
  AvoidNonAsciiSymbolsRule.ruleId: AvoidNonAsciiSymbolsRule.new,
  AvoidNonNullAssertionRule.ruleId: AvoidNonNullAssertionRule.new,
  AvoidPassingAsyncWhenSyncExpectedRule.ruleId:
      AvoidPassingAsyncWhenSyncExpectedRule.new,
  AvoidPreserveWhitespaceFalseRule.ruleId: AvoidPreserveWhitespaceFalseRule.new,
  AvoidRedundantAsyncRule.ruleId: AvoidRedundantAsyncRule.new,
  AvoidRedundantAsyncOnLoadRule.ruleId: AvoidRedundantAsyncOnLoadRule.new,
  AvoidReturningWidgetsRule.ruleId: AvoidReturningWidgetsRule.new,
  AvoidShrinkWrapInListsRule.ruleId: AvoidShrinkWrapInListsRule.new,
  AvoidSubstringRule.ruleId: AvoidSubstringRule.new,
  AvoidThrowInCatchBlockRule.ruleId: AvoidThrowInCatchBlockRule.new,
  AvoidTopLevelMembersInTestsRule.ruleId: AvoidTopLevelMembersInTestsRule.new,
  AvoidUnnecessaryConditionalsRule.ruleId: AvoidUnnecessaryConditionalsRule.new,
  AvoidUnnecessarySetStateRule.ruleId: AvoidUnnecessarySetStateRule.new,
  UseSetStateSynchronouslyRule.ruleId: UseSetStateSynchronouslyRule.new,
  AvoidUnnecessaryTypeAssertionsRule.ruleId:
      AvoidUnnecessaryTypeAssertionsRule.new,
  AvoidUnnecessaryTypeCastsRule.ruleId: AvoidUnnecessaryTypeCastsRule.new,
  AvoidUnrelatedTypeAssertionsRule.ruleId: AvoidUnrelatedTypeAssertionsRule.new,
  AvoidUnusedParametersRule.ruleId: AvoidUnusedParametersRule.new,
  AvoidWrappingInPaddingRule.ruleId: AvoidWrappingInPaddingRule.new,
  AvoidExpandedAsSpacerRule.ruleId: AvoidExpandedAsSpacerRule.new,
  BanNameRule.ruleId: BanNameRule.new,
  BinaryExpressionOperandOrderRule.ruleId: BinaryExpressionOperandOrderRule.new,
  CheckForEqualsInRenderObjectSettersRule.ruleId:
      CheckForEqualsInRenderObjectSettersRule.new,
  ComponentAnnotationArgumentsOrderingRule.ruleId:
      ComponentAnnotationArgumentsOrderingRule.new,
  ConsistentUpdateRenderObjectRule.ruleId: ConsistentUpdateRenderObjectRule.new,
  CorrectGameInstantiatingRule.ruleId: CorrectGameInstantiatingRule.new,
  DoubleLiteralFormatRule.ruleId: DoubleLiteralFormatRule.new,
  FormatCommentRule.ruleId: FormatCommentRule.new,
  ListAllEquatableFieldsRule.ruleId: ListAllEquatableFieldsRule.new,
  MemberOrderingRule.ruleId: MemberOrderingRule.new,
  MissingTestAssertionRule.ruleId: MissingTestAssertionRule.new,
  NewlineBeforeReturnRule.ruleId: NewlineBeforeReturnRule.new,
  NoBooleanLiteralCompareRule.ruleId: NoBooleanLiteralCompareRule.new,
  NoEmptyBlockRule.ruleId: NoEmptyBlockRule.new,
  NoEqualArgumentsRule.ruleId: NoEqualArgumentsRule.new,
  NoEqualThenElseRule.ruleId: NoEqualThenElseRule.new,
  NoMagicNumberRule.ruleId: NoMagicNumberRule.new,
  NoObjectDeclarationRule.ruleId: NoObjectDeclarationRule.new,
  PreferAsyncAwaitRule.ruleId: PreferAsyncAwaitRule.new,
  PreferCommentingAnalyzerIgnores.ruleId: PreferCommentingAnalyzerIgnores.new,
  PreferConditionalExpressionsRule.ruleId: PreferConditionalExpressionsRule.new,
  PreferConstBorderRadiusRule.ruleId: PreferConstBorderRadiusRule.new,
  PreferCorrectEdgeInsetsConstructorRule.ruleId:
      PreferCorrectEdgeInsetsConstructorRule.new,
  PreferCorrectIdentifierLengthRule.ruleId:
      PreferCorrectIdentifierLengthRule.new,
  PreferCorrectTestFileNameRule.ruleId: PreferCorrectTestFileNameRule.new,
  PreferCorrectTypeNameRule.ruleId: PreferCorrectTypeNameRule.new,
  PreferDefineHeroTagRule.ruleId: PreferDefineHeroTagRule.new,
  PreferEnumsByNameRule.ruleId: PreferEnumsByNameRule.new,
  PreferExtractingCallbacksRule.ruleId: PreferExtractingCallbacksRule.new,
  PreferFirstRule.ruleId: PreferFirstRule.new,
  PreferImmediateReturnRule.ruleId: PreferImmediateReturnRule.new,
  PreferIntlNameRule.ruleId: PreferIntlNameRule.new,
  PreferIterableOfRule.ruleId: PreferIterableOfRule.new,
  PreferLastRule.ruleId: PreferLastRule.new,
  PreferMatchFileNameRule.ruleId: PreferMatchFileNameRule.new,
  PreferMovingToVariableRule.ruleId: PreferMovingToVariableRule.new,
  PreferOnPushCdStrategyRule.ruleId: PreferOnPushCdStrategyRule.new,
  PreferProvideIntlDescriptionRule.ruleId: PreferProvideIntlDescriptionRule.new,
  PreferSingleWidgetPerFileRule.ruleId: PreferSingleWidgetPerFileRule.new,
  PreferStaticClassRule.ruleId: PreferStaticClassRule.new,
  PreferTrailingCommaRule.ruleId: PreferTrailingCommaRule.new,
  PreferUsingListViewRule.ruleId: PreferUsingListViewRule.new,
  ProvideCorrectIntlArgsRule.ruleId: ProvideCorrectIntlArgsRule.new,
  TagNameRule.ruleId: TagNameRule.new,
};

Iterable<String> get allRuleIds => _implementedRules.keys;

Iterable<Rule> getRulesById(Map<String, Map<String, Object>> rulesConfig) =>
    List.unmodifiable(_implementedRules.keys
        .where((id) => rulesConfig.keys.contains(id))
        .map<Rule>((id) => _implementedRules[id]!(rulesConfig[id]!)));
