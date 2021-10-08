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
        startOffsets: [24, 47, 124, 165, 222, 254, 299, 323],
        startLines: [2, 3, 7, 8, 10, 12, 16, 17],
        startColumns: [9, 9, 9, 9, 12, 12, 9, 9],
        endOffsets: [25, 48, 143, 196, 223, 255, 301, 326],
        locationTexts: [
          'x',
          'y',
          'multiplatformConfig',
          'multiplatformConfigurationPoint',
          'o',
          'p',
          'zy',
          '_ze',
        ],
        messages: [
          "The x identifier is 1 characters long. It's recommended to increase it up to 3 chars long.",
          "The y identifier is 1 characters long. It's recommended to increase it up to 3 chars long.",
          "The multiplatformConfig identifier is 19 characters long. It's recommended to decrease it to 10 chars long.",
          "The multiplatformConfigurationPoint identifier is 31 characters long. It's recommended to decrease it to 10 chars long.",
          "The o identifier is 1 characters long. It's recommended to increase it up to 3 chars long.",
          "The p identifier is 1 characters long. It's recommended to increase it up to 3 chars long.",
          "The zy identifier is 2 characters long. It's recommended to increase it up to 3 chars long.",
          "The _ze identifier is 3 characters long. It's recommended to increase it up to 3 chars long.",
        ],
      );
    });
  });
}
