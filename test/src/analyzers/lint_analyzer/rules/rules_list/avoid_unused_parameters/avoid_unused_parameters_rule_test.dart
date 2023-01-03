import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/avoid_unused_parameters/avoid_unused_parameters_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _correctExamplePath =
    'avoid_unused_parameters/examples/correct_example.dart';
const _incorrectExamplePath =
    'avoid_unused_parameters/examples/incorrect_example.dart';
const _tearOffExamplePath =
    'avoid_unused_parameters/examples/tear_off_example.dart';

void main() {
  group('AvoidUnusedParametersRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_correctExamplePath);
      final issues = AvoidUnusedParametersRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'avoid-unused-parameters',
        severity: Severity.warning,
      );
    });

    test('reports no issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_correctExamplePath);
      final issues = AvoidUnusedParametersRule().check(unit);

      RuleTestHelper.verifyNoIssues(issues);
    });

    test('reports about found issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_incorrectExamplePath);
      final issues = AvoidUnusedParametersRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [8, 11, 21, 24, 35, 29, 41, 47, 53],
        startColumns: [20, 40, 20, 20, 28, 38, 20, 23, 15],
        locationTexts: [
          'String string',
          'String secondString',
          'String string',
          'String firstString',
          'TestClass object',
          'String string',
          'TestClass object',
          'String string',
          'String value',
        ],
        messages: [
          'Parameter is unused.',
          'Parameter is unused.',
          'Parameter is unused.',
          'Parameter is unused.',
          'Parameter is unused.',
          'Parameter is unused.',
          'Parameter is unused.',
          'Parameter is unused.',
          'Parameter is unused.',
        ],
      );
    });

    test('should report about found issues for tear-offs', () async {
      final unit = await RuleTestHelper.resolveFromFile(_tearOffExamplePath);
      final issues = AvoidUnusedParametersRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [13, 13, 21, 25, 26],
        startColumns: [23, 43, 25, 5, 5],
        locationTexts: [
          'String firstString',
          'String secondString',
          'String value',
          'int value',
          'String name',
        ],
        messages: [
          'Parameter is unused.',
          'Parameter is unused.',
          'Parameter is unused.',
          'Parameter is unused.',
          'Parameter is unused.',
        ],
      );
    });
  });
}
