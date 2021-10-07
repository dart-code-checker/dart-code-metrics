import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/prefer_correct_identifier_length/prefer_correct_identifier_length.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'prefer_correct_identifier_length/examples';
const _example = '$_examplePath/example.dart';

void main() {
  group('PreferCorrectIdentifierLength', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_example);
      final issues = PreferCorrectIdentifierLength().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'prefer-correct-identifier-length',
        severity: Severity.style,
      );
    });

    test('reports about found all issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_example);
      final issues = PreferCorrectIdentifierLength({
        'max-identifier-length': 10,
        'min-identifier-length': 3,
        'exceptions': ['z'],
      }).check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startOffsets: [24, 47, 124, 165],
        startLines: [2, 3, 7, 8],
        startColumns: [9, 9, 9, 9],
        endOffsets: [25, 48, 143, 196],
        locationTexts: [
          'x',
          'y',
          'multiplatformConfig',
          'multiplatformConfigurationPoint',
        ],
        messages: [
          'Too short variable name length.',
          'Too short variable name length.',
          'Too long variable name length.',
          'Too long variable name length.',
        ],
      );
    });
  });
}
