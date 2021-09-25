import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/prefer_const_border_radius/prefer_const_border_radius.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'prefer_const_border_radius/examples/example.dart';

void main() {
  group(
    'PreferConstBorderRadiusRule',
    () {
      test('initialization', () async {
        final unit = await RuleTestHelper.resolveFromFile(_examplePath);
        final issues = PreferConstBorderRadiusRule().check(unit);

        RuleTestHelper.verifyInitialization(
          issues: issues,
          ruleId: 'prefer-const-border-radius',
          severity: Severity.performance,
        );
      });

      test('reports about found issues', () async {
        final unit = await RuleTestHelper.resolveFromFile(_examplePath);
        final issues = PreferConstBorderRadiusRule().check(unit);

        RuleTestHelper.verifyIssues(
          issues: issues,
          startOffsets: [64, 170, 261, 401],
          startLines: [2, 5, 8, 12],
          startColumns: [22, 31, 31, 31],
          endOffsets: [88, 195, 287, 426],
          messages: [
            'Prefer use const constructor BorderRadius.all.',
            'Prefer use const constructor BorderRadius.all.',
            'Prefer use const constructor BorderRadius.all.',
            'Prefer use const constructor BorderRadius.all.',
          ],
          replacementComments: [
            'Replace with const BorderRadius constructor.',
            'Replace with const BorderRadius constructor.',
            'Replace with const BorderRadius constructor.',
            'Replace with const BorderRadius constructor.',
          ],
          replacements: [
            'BorderRadius.all(Radius.circular(8))',
            'BorderRadius.all(Radius.circular(32))',
            'BorderRadius.all(Radius.circular(230))',
            'BorderRadius.all(Radius.circular(32))',
          ],
          locationTexts: [
            'BorderRadius.circular(8)',
            'BorderRadius.circular(32)',
            'BorderRadius.circular(230)',
            'BorderRadius.circular(32)',
          ],
        );
      });
    },
  );
}
