@TestOn('vm')
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/prefer_correct_identifier_length/prefer_correct_identifier_length.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'prefer_correct_identifier_length/examples';
const _example = '$_examplePath/example.dart';
const _exampleWithoutIssue = '$_examplePath/example_without_issue.dart';
const _exampleVariable = '$_examplePath/example_variable.dart';

void main() {
  group('PreferCorrectIdentifierLength', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_exampleWithoutIssue);
      final issues = PreferCorrectIdentifierLength().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'prefer-correct-identifier-length',
        severity: Severity.style,
      );
    });

    test('report no issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_exampleWithoutIssue);
      final issues = PreferCorrectIdentifierLength().check(unit);

      RuleTestHelper.verifyIssues(issues: issues);
    });

    test('reports about found short identifier name', () async {
      final unit = await RuleTestHelper.resolveFromFile(_example);
      final issues =
          PreferCorrectIdentifierLength({'max-identifier-length': '40'})
              .check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startOffsets: [259, 169, 154, 204, 228, 249, 177, 187, 24, 39],
        startLines: [20, 11, 9, 16, 18, 20, 12, 14, 2, 3],
        startColumns: [18, 7, 6, 12, 12, 8, 5, 5, 9, 9],
        endOffsets: [260, 170, 156, 205, 229, 251, 178, 188, 25, 40],
        locationTexts: [
          'y',
          'A',
          'so',
          'o',
          'p',
          'te',
          'm',
          'b',
          'x',
          'y',
        ],
        messages: [
          'Too short function argument name length.',
          'Too short class name length.',
          'Too short function name length.',
          'Too short method name length.',
          'Too short method name length.',
          'Too short method name length.',
          'Too short constructor name length.',
          'Too short constructor name length.',
          'Too short variable name length.',
          'Too short variable name length.',
        ],
      );
    });

    test('reports about found long identifier name', () async {
      final unit = await RuleTestHelper.resolveFromFile(_example);
      final issues =
          PreferCorrectIdentifierLength({'min-identifier-length': '1'})
              .check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startOffsets: [109],
        startLines: [6],
        startColumns: [9],
        endOffsets: [140],
        locationTexts: ['multiplatformConfigurationPoint'],
        messages: ['Too long variable name length.'],
      );
    });

    test('reports about found all issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_example);
      final issues = PreferCorrectIdentifierLength().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startOffsets: [
          259,
          169,
          154,
          204,
          228,
          249,
          177,
          187,
          24,
          39,
          109,
        ],
        startLines: [20, 11, 9, 16, 18, 20, 12, 14, 2, 3, 6],
        startColumns: [18, 7, 6, 12, 12, 8, 5, 5, 9, 9, 9],
        endOffsets: [
          260,
          170,
          156,
          205,
          229,
          251,
          178,
          188,
          25,
          40,
          140,
        ],
        locationTexts: [
          'y',
          'A',
          'so',
          'o',
          'p',
          'te',
          'm',
          'b',
          'x',
          'y',
          'multiplatformConfigurationPoint',
        ],
        messages: [
          'Too short function argument name length.',
          'Too short class name length.',
          'Too short function name length.',
          'Too short method name length.',
          'Too short method name length.',
          'Too short method name length.',
          'Too short constructor name length.',
          'Too short constructor name length.',
          'Too short variable name length.',
          'Too short variable name length.',
          'Too long variable name length.',
        ],
      );
    });

    test('reports about found global and local variable', () async {
      final unit = await RuleTestHelper.resolveFromFile(_exampleVariable);
      final issues =
          PreferCorrectIdentifierLength({'max-identifier-length': 15})
              .check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startOffsets: [113, 6, 53, 80],
        startLines: [6, 1, 3, 4],
        startColumns: [10, 7, 9, 9],
        endOffsets: [114, 25, 54, 81],
        locationTexts: ['m', '_someGlobalConstant', 'a', 'b'],
        messages: [
          'Too short function name length.',
          'Too long variable name length.',
          'Too short variable name length.',
          'Too short variable name length.',
        ],
      );
    });

    test('reports no issue configure rule', () async {
      final unit = await RuleTestHelper.resolveFromFile(_example);
      final issues = PreferCorrectIdentifierLength({
        'check-variable-name': false,
        'check-class-name': false,
        'check-function-name': false,
        'check-getters-name': false,
        'check-setters-name': false,
        'check-method-name': false,
        'check-named-constructor-name': false,
        'check-argument-name': false,
      }).check(unit);

      RuleTestHelper.verifyNoIssues(issues);
    });
  });
}
