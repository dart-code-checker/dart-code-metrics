import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/prefer_moving_to_variable/prefer_moving_to_variable_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'prefer_moving_to_variable/examples/example.dart';
const _cascadeExamplePath =
    'prefer_moving_to_variable/examples/cascade_example.dart';

void main() {
  group('PreferMovingToVariableRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = PreferMovingToVariableRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'prefer-moving-to-variable',
        severity: Severity.warning,
      );
    });

    test('reports about found issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = PreferMovingToVariableRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [
          2,
          3,
          7,
          8,
          10,
          11,
          13,
          14,
          19,
          20,
          22,
          23,
          25,
          26,
          28,
          29,
          44,
          45,
        ],
        startColumns: [
          19,
          22,
          3,
          3,
          3,
          3,
          3,
          3,
          3,
          3,
          3,
          3,
          3,
          3,
          3,
          3,
          5,
          5,
        ],
        locationTexts: [
          "Theme.of('color').trim()",
          "Theme.of('color').trim()",
          "string.indexOf('').sign",
          "string.indexOf('').sign",
          'getValue()',
          'getValue()',
          'getValue()',
          'getValue()',
          'Theme.after().value',
          'Theme.after().value',
          'Theme.from().value',
          'Theme.from().value',
          'Theme.from().someMethod()',
          'Theme.from().someMethod()',
          'getValue()',
          'getValue()',
          "string.indexOf('').sign",
          "string.indexOf('').sign",
        ],
        messages: [
          'Prefer moving repeated invocations to variable and use it instead.',
          'Prefer moving repeated invocations to variable and use it instead.',
          'Prefer moving repeated invocations to variable and use it instead.',
          'Prefer moving repeated invocations to variable and use it instead.',
          'Prefer moving repeated invocations to variable and use it instead.',
          'Prefer moving repeated invocations to variable and use it instead.',
          'Prefer moving repeated invocations to variable and use it instead.',
          'Prefer moving repeated invocations to variable and use it instead.',
          'Prefer moving repeated invocations to variable and use it instead.',
          'Prefer moving repeated invocations to variable and use it instead.',
          'Prefer moving repeated invocations to variable and use it instead.',
          'Prefer moving repeated invocations to variable and use it instead.',
          'Prefer moving repeated invocations to variable and use it instead.',
          'Prefer moving repeated invocations to variable and use it instead.',
          'Prefer moving repeated invocations to variable and use it instead.',
          'Prefer moving repeated invocations to variable and use it instead.',
          'Prefer moving repeated invocations to variable and use it instead.',
          'Prefer moving repeated invocations to variable and use it instead.',
        ],
      );
    });

    test('reports no issues for cascade', () async {
      final unit = await RuleTestHelper.resolveFromFile(_cascadeExamplePath);
      final issues = PreferMovingToVariableRule().check(unit);

      RuleTestHelper.verifyNoIssues(issues);
    });
  });
}
