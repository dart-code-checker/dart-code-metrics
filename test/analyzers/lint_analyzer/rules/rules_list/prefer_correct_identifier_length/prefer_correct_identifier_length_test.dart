import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/prefer_correct_identifier_length/prefer_correct_identifier_length.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'prefer_correct_identifier_length/examples';
const _example = '$_examplePath/example.dart';

void main() {
  group('PreferCorrectIdentifierLength', () {
    test('reports about found all issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_example);
      final issues = PreferCorrectIdentifierLength({
        'exceptions': ['z'],
      }).check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startOffsets: [24, 39, 124],
        startLines: [2, 3, 7],
        startColumns: [9, 9, 9],
        endOffsets: [25, 40, 155],
        locationTexts: [
          'x',
          'y',
          'multiplatformConfigurationPoint',
        ],
        messages: [
          'Too short variable name length.',
          'Too short variable name length.',
          'Too long variable name length.',
        ],
      );
    });
  });
}
