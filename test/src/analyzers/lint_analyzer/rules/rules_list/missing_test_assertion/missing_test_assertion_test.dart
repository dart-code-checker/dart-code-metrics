import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/missing_test_assertion/missing_test_assertion_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _correctExamplePath =
    'missing_test_assertion/examples/correct_example.dart';
const _incorrectExamplePath =
    'missing_test_assertion/examples/incorrect_example.dart';
const _customAssertionsExamplePath =
    'missing_test_assertion/examples/custom_assertions_example.dart';
const _customMethodsExamplePath =
    'missing_test_assertion/examples/custom_methods_example.dart';

void main() {
  group('MissingTestAssertion', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_correctExamplePath);
      final issues = MissingTestAssertionRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'missing-test-assertion',
        severity: Severity.warning,
      );
    });

    test('with default config reports no issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_correctExamplePath);
      final issues = MissingTestAssertionRule().check(unit);

      RuleTestHelper.verifyNoIssues(issues);
    });

    test('with custom assertions config reports no issues', () async {
      final unit =
          await RuleTestHelper.resolveFromFile(_customAssertionsExamplePath);
      final config = {
        'include-assertions': [
          'verify',
        ],
      };
      final issues = MissingTestAssertionRule(config).check(unit);

      RuleTestHelper.verifyNoIssues(issues);
    });

    test('with default config reports about found issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_incorrectExamplePath);
      final issues = MissingTestAssertionRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [4, 10, 15],
        startColumns: [3, 3, 3],
        locationTexts: [
          "test('bad unit test', () {\n"
              '    final a = 1;\n'
              '    final b = 2;\n'
              '    final c = a + 1;\n'
              '  })',
          "testWidgets('bad widget test', (WidgetTester tester) async {\n"
              '    await tester.pumpWidget(MyApp());\n'
              '    await tester.pumpAndSettle();\n'
              '  })',
          'test(null, () => 1 == 1)',
        ],
        messages: [
          'Missing test assertion.',
          'Missing test assertion.',
          'Missing test assertion.',
        ],
      );
    });

    test('with custom methods config reports about found issues', () async {
      final unit =
          await RuleTestHelper.resolveFromFile(_customMethodsExamplePath);
      final config = {
        'include-methods': [
          'customTest',
          'otherTestMethod',
        ],
      };
      final issues = MissingTestAssertionRule(config).check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [4, 6],
        startColumns: [3, 3],
        locationTexts: [
          'customTest(null, () => 1 == 1)',
          'otherTestMethod(null, () => 1 == 1)',
        ],
        messages: [
          'Missing test assertion.',
          'Missing test assertion.',
        ],
      );
    });
  });
}
