import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/prefer_correct_identifier_length/prefer_correct_identifier_length_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _path = 'prefer_correct_identifier_length/examples';
const _classExample = '$_path/class_example.dart';
const _commonExample = '$_path/common_example.dart';
const _enumExample = '$_path/enum_example.dart';
const _mixinExample = '$_path/mixin_example.dart';
const _extensionExample = '$_path/extension_example.dart';
const _withoutErrorExample = '$_path/without_error_example.dart';

void main() {
  group('PreferCorrectIdentifierLengthRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_classExample);
      final issues = PreferCorrectIdentifierLengthRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'prefer-correct-identifier-length',
        severity: Severity.style,
      );
    });

    test('reports no issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_withoutErrorExample);
      final issues = PreferCorrectIdentifierLengthRule().check(unit);

      RuleTestHelper.verifyNoIssues(issues);
    });

    test('reports about found all issues in class_example.dart', () async {
      final unit = await RuleTestHelper.resolveFromFile(_classExample);
      final issues = PreferCorrectIdentifierLengthRule({
        'max-identifier-length': 10,
        'min-identifier-length': 3,
        'exceptions': ['z'],
      }).check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [2, 3, 7, 8, 11, 12, 16, 17, 20, 22, 25, 26],
        startColumns: [9, 9, 9, 9, 11, 11, 11, 11, 12, 12, 11, 11],
        locationTexts: [
          'x',
          'y',
          'multiplatformConfig',
          'multiplatformConfigurationPoint',
          'u',
          'i',
          'u',
          'i',
          'o',
          'p',
          'u',
          'i',
        ],
        messages: [
          "The x identifier is 1 characters long. It's recommended to increase it up to 3 chars long.",
          "The y identifier is 1 characters long. It's recommended to increase it up to 3 chars long.",
          "The multiplatformConfig identifier is 19 characters long. It's recommended to decrease it to 10 chars long.",
          "The multiplatformConfigurationPoint identifier is 31 characters long. It's recommended to decrease it to 10 chars long.",
          "The u identifier is 1 characters long. It's recommended to increase it up to 3 chars long.",
          "The i identifier is 1 characters long. It's recommended to increase it up to 3 chars long.",
          "The u identifier is 1 characters long. It's recommended to increase it up to 3 chars long.",
          "The i identifier is 1 characters long. It's recommended to increase it up to 3 chars long.",
          "The o identifier is 1 characters long. It's recommended to increase it up to 3 chars long.",
          "The p identifier is 1 characters long. It's recommended to increase it up to 3 chars long.",
          "The u identifier is 1 characters long. It's recommended to increase it up to 3 chars long.",
          "The i identifier is 1 characters long. It's recommended to increase it up to 3 chars long.",
        ],
      );
    });

    test('reports about found all issues in common_example.dart', () async {
      final unit = await RuleTestHelper.resolveFromFile(_commonExample);
      final issues = PreferCorrectIdentifierLengthRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [2, 3, 6, 7],
        startColumns: [9, 9, 7, 7],
        locationTexts: ['zy', '_ze', 'u', 'i'],
        messages: [
          "The zy identifier is 2 characters long. It's recommended to increase it up to 3 chars long.",
          "The _ze identifier is 3 characters long. It's recommended to increase it up to 3 chars long.",
          "The u identifier is 1 characters long. It's recommended to increase it up to 3 chars long.",
          "The i identifier is 1 characters long. It's recommended to increase it up to 3 chars long.",
        ],
      );
    });

    test('reports about found all issues in enum_example.dart', () async {
      final unit = await RuleTestHelper.resolveFromFile(_enumExample);
      final issues = PreferCorrectIdentifierLengthRule({
        'max-identifier-length': 10,
        'min-identifier-length': 3,
      }).check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [2, 3],
        startColumns: [3, 3],
        locationTexts: ['u', 'i'],
        messages: [
          "The u identifier is 1 characters long. It's recommended to increase it up to 3 chars long.",
          "The i identifier is 1 characters long. It's recommended to increase it up to 3 chars long.",
        ],
      );
    });

    test('reports about found all issues in extension_example.dart', () async {
      final unit = await RuleTestHelper.resolveFromFile(_extensionExample);
      final issues = PreferCorrectIdentifierLengthRule({
        'max-identifier-length': 10,
        'min-identifier-length': 3,
      }).check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [3, 4],
        startColumns: [11, 11],
        locationTexts: ['u', 'i'],
        messages: [
          "The u identifier is 1 characters long. It's recommended to increase it up to 3 chars long.",
          "The i identifier is 1 characters long. It's recommended to increase it up to 3 chars long.",
        ],
      );
    });

    test('reports about found all issues in mixin_example.dart', () async {
      final unit = await RuleTestHelper.resolveFromFile(_mixinExample);
      final issues = PreferCorrectIdentifierLengthRule({
        'max-identifier-length': 10,
        'min-identifier-length': 3,
      }).check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [2, 3],
        startColumns: [9, 9],
        locationTexts: ['u', 'i'],
        messages: [
          "The u identifier is 1 characters long. It's recommended to increase it up to 3 chars long.",
          "The i identifier is 1 characters long. It's recommended to increase it up to 3 chars long.",
        ],
      );
    });
  });
}
