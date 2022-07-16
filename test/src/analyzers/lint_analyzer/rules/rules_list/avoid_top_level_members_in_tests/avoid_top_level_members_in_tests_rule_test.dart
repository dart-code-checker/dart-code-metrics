import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/avoid_top_level_members_in_tests/avoid_top_level_members_in_tests_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'avoid_top_level_members_in_tests/examples/example.dart';

void main() {
  group('AvoidTopLevelMembersInTestsRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = AvoidTopLevelMembersInTestsRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'avoid-top-level-members-in-tests',
        severity: Severity.warning,
      );
    });

    test('reports about found issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = AvoidTopLevelMembersInTestsRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [1, 6, 10, 14, 18, 22, 26],
        startColumns: [7, 1, 1, 1, 1, 1, 1],
        locationTexts: [
          'public = 1',
          'void function() {}',
          'class Class {}',
          'mixin Mixin {}',
          'extension Extension on String {}',
          'enum Enum { first, second }',
          'typedef Public = String;',
        ],
        messages: [
          'Avoid declaring top-level members in tests.',
          'Avoid declaring top-level members in tests.',
          'Avoid declaring top-level members in tests.',
          'Avoid declaring top-level members in tests.',
          'Avoid declaring top-level members in tests.',
          'Avoid declaring top-level members in tests.',
          'Avoid declaring top-level members in tests.',
        ],
      );
    });
  });
}
