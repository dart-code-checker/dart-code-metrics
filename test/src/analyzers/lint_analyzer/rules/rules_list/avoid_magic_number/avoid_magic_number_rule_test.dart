import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/avoid_magic_number/avoid_magic_number_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'avoid_magic_number/examples/example.dart';
const _incorrectExamplePath =
    'avoid_magic_number/examples/incorrect_example.dart';
const _exceptionsExamplePath =
    'avoid_magic_number/examples/exceptions_example.dart';
const _arrayExamplePath = 'avoid_magic_number/examples/array_example.dart';

void main() {
  group('AvoidMagicNumberRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = AvoidMagicNumberRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'avoid-magic-number',
        severity: Severity.warning,
      );
    });

    test('reports magic numbers', () async {
      final unit = await RuleTestHelper.resolveFromFile(_incorrectExamplePath);
      final issues = AvoidMagicNumberRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [1, 2, 3, 4],
        startColumns: [26, 28, 27, 25],
        locationTexts: ['42', '12', '3.14', '12'],
      );
    });

    test("doesn't report constants", () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = AvoidMagicNumberRule().check(unit);

      RuleTestHelper.verifyNoIssues(issues);
    });

    test("doesn't report exceptional code", () async {
      final unit = await RuleTestHelper.resolveFromFile(_exceptionsExamplePath);
      final issues = AvoidMagicNumberRule().check(unit);

      RuleTestHelper.verifyNoIssues(issues);
    });

    test("doesn't report magic numbers allowed in config", () async {
      final unit = await RuleTestHelper.resolveFromFile(_incorrectExamplePath);
      final config = {
        'allowed': [42, 12, 3.14],
      };

      final issues = AvoidMagicNumberRule(config).check(unit);

      RuleTestHelper.verifyNoIssues(issues);
    });

    test(
      'reports magic numbers in objects in widget array structures',
      () async {
        final unit = await RuleTestHelper.resolveFromFile(_arrayExamplePath);
        final issues = AvoidMagicNumberRule().check(unit);

        RuleTestHelper.verifyIssues(
          issues: issues,
          startLines: [8, 11],
          startColumns: [15, 19],
          locationTexts: ['83', '83'],
        );
      },
    );
  });
}
