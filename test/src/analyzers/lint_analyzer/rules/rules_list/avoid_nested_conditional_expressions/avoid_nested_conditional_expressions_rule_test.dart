import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/avoid_nested_conditional_expressions/avoid_nested_conditional_expressions_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath =
    'avoid_nested_conditional_expressions/examples/example.dart';

void main() {
  group('AvoidNestedConditionalExpressionsRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = AvoidNestedConditionalExpressionsRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'avoid-nested-conditional-expressions',
        severity: Severity.style,
      );
    });

    test('reports no issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);

      final config = {'acceptable-level': 5};

      final issues = AvoidNestedConditionalExpressionsRule(config).check(unit);

      RuleTestHelper.verifyNoIssues(issues);
    });

    test('reports about found issues with default config', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = AvoidNestedConditionalExpressionsRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [7, 13, 14, 21, 22, 23],
        startColumns: [9, 9, 13, 9, 13, 17],
        locationTexts: [
          'str.isEmpty // LINT\n'
              "          ? 'hello'\n"
              "          : 'world'",
          'str.isEmpty // LINT\n'
              '          ? str.isEmpty // LINT\n'
              "              ? 'hi'\n"
              "              : 'hello'\n"
              "          : 'here'",
          'str.isEmpty // LINT\n'
              "              ? 'hi'\n"
              "              : 'hello'",
          'str.isEmpty // LINT\n'
              '          ? str.isEmpty // LINT\n'
              '              ? str.isEmpty // LINT\n'
              "                  ? 'hi'\n"
              "                  : 'hello'\n"
              "              : 'here'\n"
              "          : 'deep'",
          'str.isEmpty // LINT\n'
              '              ? str.isEmpty // LINT\n'
              "                  ? 'hi'\n"
              "                  : 'hello'\n"
              "              : 'here'",
          'str.isEmpty // LINT\n'
              "                  ? 'hi'\n"
              "                  : 'hello'",
        ],
        messages: [
          'Avoid nested conditional expressions.',
          'Avoid nested conditional expressions.',
          'Avoid nested conditional expressions.',
          'Avoid nested conditional expressions.',
          'Avoid nested conditional expressions.',
          'Avoid nested conditional expressions.',
        ],
      );
    });

    test('reports about found issues with custom config', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);

      final config = {'acceptable-level': 2};

      final issues = AvoidNestedConditionalExpressionsRule(config).check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [14, 22, 23],
        startColumns: [13, 13, 17],
        locationTexts: [
          'str.isEmpty // LINT\n'
              "              ? 'hi'\n"
              "              : 'hello'",
          'str.isEmpty // LINT\n'
              '              ? str.isEmpty // LINT\n'
              "                  ? 'hi'\n"
              "                  : 'hello'\n"
              "              : 'here'",
          'str.isEmpty // LINT\n'
              "                  ? 'hi'\n"
              "                  : 'hello'",
        ],
        messages: [
          'Avoid nested conditional expressions.',
          'Avoid nested conditional expressions.',
          'Avoid nested conditional expressions.',
        ],
      );
    });
  });
}
