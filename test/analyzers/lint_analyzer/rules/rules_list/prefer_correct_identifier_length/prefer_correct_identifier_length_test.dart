import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/prefer_correct_identifier_length/prefer_correct_identifier_length.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _path = 'prefer_correct_identifier_length/examples';
const _classExample = '$_path/class_example.dart';
const _commonExample = '$_path/common_example.dart';
const _enumExample = '$_path/enum_example.dart';
const _mixinExample = '$_path/mixin_example.dart';
const _extensionExample = '$_path/extension_example.dart';

void main() {
  group('PreferCorrectIdentifierLength', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_classExample);
      final issues = PreferCorrectIdentifierLength().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'prefer-correct-identifier-length',
        severity: Severity.style,
      );
    });

    test('reports about found all issues in class_example.dart', () async {
      final unit = await RuleTestHelper.resolveFromFile(_classExample);
      final issues = PreferCorrectIdentifierLength({
        'max-identifier-length': 10,
        'min-identifier-length': 3,
        'exceptions': ['z'],
      }).check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startOffsets: [
          24,
          47,
          124,
          165,
          240,
          265,
          311,
          336,
          367,
          399,
          447,
          472,
        ],
        startLines: [2, 3, 7, 8, 11, 12, 16, 17, 20, 22, 25, 26],
        startColumns: [9, 9, 9, 9, 11, 11, 11, 11, 12, 12, 11, 11],
        endOffsets: [
          25,
          48,
          143,
          196,
          241,
          266,
          312,
          337,
          368,
          400,
          448,
          473,
        ],
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
      final issues = PreferCorrectIdentifierLength({
        'max-identifier-length': 10,
        'min-identifier-length': 3,
        'exceptions': ['z'],
      }).check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startOffsets: [22, 46, 72, 93],
        startLines: [2, 3, 6, 7],
        startColumns: [9, 9, 7, 7],
        endOffsets: [24, 49, 73, 94],
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
      final issues = PreferCorrectIdentifierLength({
        'max-identifier-length': 10,
        'min-identifier-length': 3,
      }).check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startOffsets: [14, 19],
        startLines: [2, 3],
        startColumns: [3, 3],
        endOffsets: [15, 20],
        locationTexts: ['u', 'i'],
        messages: [
          "The u identifier is 1 characters long. It's recommended to increase it up to 3 chars long.",
          "The i identifier is 1 characters long. It's recommended to increase it up to 3 chars long.",
        ],
      );
    });

    test('reports about found all issues in extension_example.dart', () async {
      final unit = await RuleTestHelper.resolveFromFile(_extensionExample);
      final issues = PreferCorrectIdentifierLength({
        'max-identifier-length': 10,
        'min-identifier-length': 3,
      }).check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startOffsets: [60, 85],
        startLines: [3, 4],
        startColumns: [11, 11],
        endOffsets: [61, 86],
        locationTexts: ['u', 'i'],
        messages: [
          "The u identifier is 1 characters long. It's recommended to increase it up to 3 chars long.",
          "The i identifier is 1 characters long. It's recommended to increase it up to 3 chars long.",
        ],
      );
    });

    test('reports about found all issues in mixin_example.dart', () async {
      final unit = await RuleTestHelper.resolveFromFile(_mixinExample);
      final issues = PreferCorrectIdentifierLength({
        'max-identifier-length': 10,
        'min-identifier-length': 3,
      }).check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startOffsets: [22, 45],
        startLines: [2, 3],
        startColumns: [9, 9],
        endOffsets: [23, 46],
        locationTexts: ['u', 'i'],
        messages: [
          "The u identifier is 1 characters long. It's recommended to increase it up to 3 chars long.",
          "The i identifier is 1 characters long. It's recommended to increase it up to 3 chars long.",
        ],
      );
    });
  });
}
