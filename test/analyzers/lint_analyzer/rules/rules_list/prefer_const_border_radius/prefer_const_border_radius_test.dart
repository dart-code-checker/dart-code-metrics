import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/prefer_const_border_radius/prefer_const_border_radius.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'prefer_const_border_radius/example';
const _exampleClass = '$_examplePath/example.dart';

void main() {
  test('reports border const', () async {
    final unit = await RuleTestHelper.resolveFromFile(_exampleClass);
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
}
