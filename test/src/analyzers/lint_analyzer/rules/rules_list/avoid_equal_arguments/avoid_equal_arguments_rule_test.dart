import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/avoid_equal_arguments/avoid_equal_arguments_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'avoid_equal_arguments/examples/example.dart';
const _incorrectExamplePath =
    'avoid_equal_arguments/examples/incorrect_example.dart';
const _namedParametersExamplePath =
    'avoid_equal_arguments/examples/named_parameters_example.dart';

void main() {
  group('NoEqualArgumentsRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = AvoidEqualArgumentsRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'avoid-equal-arguments',
        severity: Severity.warning,
      );
    });

    test('reports about found issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_incorrectExamplePath);
      final issues = AvoidEqualArgumentsRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [17, 32, 37, 42, 47, 54, 59],
        startColumns: [5, 5, 5, 5, 5, 5, 5],
        locationTexts: [
          'firstName',
          'user.firstName',
          'user.getName',
          'user.getFirstName()',
          "user.getNewName('name')",
          'user.getNewName(name)',
          'lastName: user.firstName',
        ],
        messages: [
          'The argument has already been passed.',
          'The argument has already been passed.',
          'The argument has already been passed.',
          'The argument has already been passed.',
          'The argument has already been passed.',
          'The argument has already been passed.',
          'The argument has already been passed.',
        ],
      );
    });

    test('reports no issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = AvoidEqualArgumentsRule().check(unit);

      RuleTestHelper.verifyNoIssues(issues);
    });
  });

  test('reports about found issue with default config', () async {
    final unit =
        await RuleTestHelper.resolveFromFile(_namedParametersExamplePath);
    final issues = AvoidEqualArgumentsRule().check(unit);

    RuleTestHelper.verifyIssues(
      issues: issues,
      startLines: [9],
      startColumns: [3],
      locationTexts: ['lastName: firstName'],
      messages: ['The argument has already been passed.'],
    );
  });

  test('reports no issues with custom config', () async {
    final unit =
        await RuleTestHelper.resolveFromFile(_namedParametersExamplePath);
    final config = {
      'ignored-parameters': [
        'lastName',
      ],
    };

    final issues = AvoidEqualArgumentsRule(config).check(unit);

    RuleTestHelper.verifyNoIssues(issues);
  });
}
