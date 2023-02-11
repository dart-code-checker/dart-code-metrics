import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/prefer_moving_to_variable/prefer_moving_to_variable_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'prefer_moving_to_variable/examples/example.dart';
const _argumentsExamplePath =
    'prefer_moving_to_variable/examples/arguments_example.dart';
const _argumentsWithObjectExamplePath =
    'prefer_moving_to_variable/examples/arguments_with_object_example.dart';
const _scopeExamplePath =
    'prefer_moving_to_variable/examples/scope_example.dart';
const _cascadeExamplePath =
    'prefer_moving_to_variable/examples/cascade_example.dart';
const _genericsExamplePath =
    'prefer_moving_to_variable/examples/generics_example.dart';
const _assignmentExamplePath =
    'prefer_moving_to_variable/examples/assignment_example.dart';
const _prefixExamplePath =
    'prefer_moving_to_variable/examples/prefix_example.dart';
const _providerExamplePath =
    'prefer_moving_to_variable/examples/provider_example.dart';
const _whileExamplePath =
    'prefer_moving_to_variable/examples/while_example.dart';

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
          31,
          32,
          19,
          20,
          22,
          23,
          28,
          29,
          47,
          48,
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
          'getValue()',
          'getValue()',
          'Theme.after().value',
          'Theme.after().value',
          'Theme.from().value',
          'Theme.from().value',
          'Theme.from().notVoidMethod()',
          'Theme.from().notVoidMethod()',
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

    test(
      'reports about found issues for invocations with arguments example',
      () async {
        final unit =
            await RuleTestHelper.resolveFromFile(_argumentsExamplePath);
        final issues = PreferMovingToVariableRule().check(unit);

        RuleTestHelper.verifyIssues(
          issues: issues,
          startLines: [7, 8, 10, 11, 15, 20, 21, 23, 26, 32, 33],
          startColumns: [3, 3, 3, 3, 3, 3, 3, 3, 5, 3, 3],
          locationTexts: [
            "methodWithArguments('world')",
            "methodWithArguments('world')",
            'methodWithArguments(someValue)',
            'methodWithArguments(someValue)',
            'methodWithArguments(someValue)',
            "methodWithNamedArguments(firstName: 'hello')",
            "methodWithNamedArguments(firstName: 'hello')",
            "methodWithNamedArguments(lastName: 'last')",
            "methodWithNamedArguments(lastName: 'last')",
            "methodWithMixedArguments(someValue, named: 'name')",
            "methodWithMixedArguments(someValue, named: 'name')",
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
          ],
        );
      },
    );

    test(
      'reports about found issues for invocations on object with arguments  example',
      () async {
        final unit = await RuleTestHelper.resolveFromFile(
          _argumentsWithObjectExamplePath,
        );
        final issues = PreferMovingToVariableRule().check(unit);

        RuleTestHelper.verifyIssues(
          issues: issues,
          startLines: [9, 10, 12, 13, 17, 22, 23, 25, 28, 34, 35],
          startColumns: [3, 3, 3, 3, 3, 3, 3, 3, 5, 3, 3],
          locationTexts: [
            "state.methodWithArguments('world')",
            "state.methodWithArguments('world')",
            'state.methodWithArguments(someValue)',
            'state.methodWithArguments(someValue)',
            'state.methodWithArguments(someValue)',
            "state.methodWithNamedArguments(firstName: 'hello')",
            "state.methodWithNamedArguments(firstName: 'hello')",
            "state.methodWithNamedArguments(lastName: 'last')",
            "state.methodWithNamedArguments(lastName: 'last')",
            "state.methodWithMixedArguments(someValue, named: 'name')",
            "state.methodWithMixedArguments(someValue, named: 'name')",
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
          ],
        );
      },
    );

    test('reports no issues for scope', () async {
      final unit = await RuleTestHelper.resolveFromFile(_scopeExamplePath);
      final issues = PreferMovingToVariableRule().check(unit);

      RuleTestHelper.verifyNoIssues(issues);
    });

    test('reports no issues for cascade', () async {
      final unit = await RuleTestHelper.resolveFromFile(_cascadeExamplePath);
      final issues = PreferMovingToVariableRule().check(unit);

      RuleTestHelper.verifyNoIssues(issues);
    });

    test('reports no issues for assignments', () async {
      final unit = await RuleTestHelper.resolveFromFile(_assignmentExamplePath);
      final issues = PreferMovingToVariableRule().check(unit);

      RuleTestHelper.verifyNoIssues(issues);
    });

    test('reports no issues for generics', () async {
      final unit = await RuleTestHelper.resolveFromFile(_genericsExamplePath);
      final issues = PreferMovingToVariableRule().check(unit);

      RuleTestHelper.verifyNoIssues(issues);
    });

    test('reports no issues for prefix imports', () async {
      final unit = await RuleTestHelper.resolveFromFile(_prefixExamplePath);
      final issues = PreferMovingToVariableRule().check(unit);

      RuleTestHelper.verifyNoIssues(issues);
    });

    test('reports no issues for provider read', () async {
      final unit = await RuleTestHelper.resolveFromFile(_providerExamplePath);
      final issues = PreferMovingToVariableRule().check(unit);

      RuleTestHelper.verifyNoIssues(issues);
    });

    test('reports no issues for while', () async {
      final unit = await RuleTestHelper.resolveFromFile(_whileExamplePath);
      final issues = PreferMovingToVariableRule().check(unit);

      RuleTestHelper.verifyNoIssues(issues);
    });

    test('reports issues with custom config', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final config = {
        'allowed-duplicated-chains': 3,
      };
      final issues = PreferMovingToVariableRule(config).check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [10, 11, 13, 14, 31, 32],
        startColumns: [3, 3, 3, 3, 3, 3],
        locationTexts: [
          'getValue()',
          'getValue()',
          'getValue()',
          'getValue()',
          'getValue()',
          'getValue()',
        ],
        messages: [
          'Prefer moving repeated invocations to variable and use it instead.',
          'Prefer moving repeated invocations to variable and use it instead.',
          'Prefer moving repeated invocations to variable and use it instead.',
          'Prefer moving repeated invocations to variable and use it instead.',
          'Prefer moving repeated invocations to variable and use it instead.',
          'Prefer moving repeated invocations to variable and use it instead.',
        ],
      );
    });
  });
}
