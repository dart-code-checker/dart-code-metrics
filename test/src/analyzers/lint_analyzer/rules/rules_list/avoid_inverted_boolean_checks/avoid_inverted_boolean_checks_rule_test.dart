import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/avoid_inverted_boolean_checks/avoid_inverted_boolean_checks_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'avoid_inverted_boolean_checks/examples/example.dart';

void main() {
  group(
    'AvoidInvertedBooleanChecksRule',
    () {
      test('initialization', () async {
        final unit = await RuleTestHelper.resolveFromFile(_examplePath);
        final issues = AvoidInvertedBooleanChecksRule().check(unit);

        RuleTestHelper.verifyInitialization(
          issues: issues,
          ruleId: 'avoid-inverted-boolean-checks',
          severity: Severity.style,
        );
      });

      test('reports about found issues', () async {
        final unit = await RuleTestHelper.resolveFromFile(_examplePath);
        final issues = AvoidInvertedBooleanChecksRule().check(unit);

        RuleTestHelper.verifyIssues(
          issues: issues,
          startLines: [2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22],
          startColumns: [7, 7, 7, 7, 7, 7, 11, 13, 12, 7, 19],
          messages: [
            'Avoid inverted boolean checks.',
            'Avoid inverted boolean checks.',
            'Avoid inverted boolean checks.',
            'Avoid inverted boolean checks.',
            'Avoid inverted boolean checks.',
            'Avoid inverted boolean checks.',
            'Avoid inverted boolean checks.',
            'Avoid inverted boolean checks.',
            'Avoid inverted boolean checks.',
            'Avoid inverted boolean checks.',
            'Avoid inverted boolean checks.',
          ],
          locationTexts: [
            '!(x == 1)',
            '!(x != 1)',
            '!(x > 1)',
            '!(x < 1)',
            '!(x >= 1)',
            '!(x <= 1)',
            '!(x != 1)',
            '!(x <= 4)',
            '!(x == 1)',
            '!(a > 4 && b < 2)',
            '!(x == 1)',
          ],
        );
      });
    },
  );
}
