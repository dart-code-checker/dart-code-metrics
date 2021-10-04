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
          startOffsets: [82, 242, 342, 409, 557, 839],
          startLines: [2, 7, 10, 11, 15, 20],
          startColumns: [22, 31, 31, 32, 31, 31],
          endOffsets: [108, 268, 368, 435, 583, 873],
          messages: [
            'Prefer using const constructor BorderRadius.all',
            'Prefer using const constructor BorderRadius.all',
            'Prefer using const constructor BorderRadius.all',
            'Prefer using const constructor BorderRadius.all',
            'Prefer using const constructor BorderRadius.all',
            'Prefer using const constructor BorderRadius.all',
          ],
          replacementComments: [
            'Replace with const BorderRadius constructor.',
            'Replace with const BorderRadius constructor.',
            'Replace with const BorderRadius constructor.',
            'Replace with const BorderRadius constructor.',
            'Replace with const BorderRadius constructor.',
            'Replace with const BorderRadius constructor.',
          ],
          replacements: [
            'BorderRadius.all(Radius.circular(1.0))',
            'BorderRadius.all(Radius.circular(2.0))',
            'BorderRadius.all(Radius.circular(3.0))',
            'BorderRadius.all(Radius.circular(4.0))',
            'BorderRadius.all(Radius.circular(5.0))',
            'BorderRadius.all(Radius.circular(_constValue))',
          ],
          locationTexts: [
            'BorderRadius.circular(1.0)',
            'BorderRadius.circular(2.0)',
            'BorderRadius.circular(3.0)',
            'BorderRadius.circular(4.0)',
            'BorderRadius.circular(5.0)',
            'BorderRadius.circular(_constValue)',
          ],
        );
      });
    },
  );
}
