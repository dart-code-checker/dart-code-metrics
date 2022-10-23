import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/prefer_trailing_comma/prefer_trailing_comma_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

// ignore_for_file: avoid_escaping_inner_quotes

const _correctExamplePath =
    'prefer_trailing_comma/examples/correct_example.dart';
const _incorrectExamplePath =
    'prefer_trailing_comma/examples/incorrect_example.dart';

void main() {
  group('PreferTrailingCommaRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_correctExamplePath);
      final issues = PreferTrailingCommaRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'prefer-trailing-comma',
        severity: Severity.style,
      );
    });

    test('with default config reports about found issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_incorrectExamplePath);
      final issues = PreferTrailingCommaRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [3, 9, 13, 18, 24, 28, 49, 58, 64, 70],
        startColumns: [50, 7, 5, 52, 9, 8, 59, 3, 3, 3],
        locationTexts: [
          'String thirdArgument',
          "'and another string for length exceed'",
          'String arg3',
          'String thirdArgument',
          "'and another string for length exceed'",
          "'some other string'",
          'this.forthField',
          "'and another string for length exceed'",
          "'and another string for length exceed'",
          "'and another string for length exceed': 'and another string for length exceed'",
        ],
        messages: [
          'Prefer trailing comma.',
          'Prefer trailing comma.',
          'Prefer trailing comma.',
          'Prefer trailing comma.',
          'Prefer trailing comma.',
          'Prefer trailing comma.',
          'Prefer trailing comma.',
          'Prefer trailing comma.',
          'Prefer trailing comma.',
          'Prefer trailing comma.',
        ],
        replacementComments: [
          'Add trailing comma.',
          'Add trailing comma.',
          'Add trailing comma.',
          'Add trailing comma.',
          'Add trailing comma.',
          'Add trailing comma.',
          'Add trailing comma.',
          'Add trailing comma.',
          'Add trailing comma.',
          'Add trailing comma.',
        ],
        replacements: [
          'String thirdArgument,',
          "'and another string for length exceed',",
          'String arg3,',
          'String thirdArgument,',
          "'and another string for length exceed',",
          "'some other string',",
          'this.forthField,',
          "'and another string for length exceed',",
          "'and another string for length exceed',",
          "'and another string for length exceed': 'and another string for length exceed',",
        ],
      );
    });

    test('with default config reports no issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_correctExamplePath);
      final issues = PreferTrailingCommaRule().check(unit);

      RuleTestHelper.verifyNoIssues(issues);
    });

    test('with custom config reports about found issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_correctExamplePath);
      final config = {'break-on': 1};

      final issues = PreferTrailingCommaRule(config).check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [9, 17, 19, 37, 41, 91, 99, 109, 119],
        startColumns: [21, 33, 20, 23, 19, 43, 21, 19, 19],
        locationTexts: [
          'String arg1',
          'void Function() callback',
          'void Function() callback',
          '() {\n'
              '      return;\n'
              '    }',
          '() {\n'
              '      return;\n'
              '    }',
          '0',
          '\'some string\'',
          '\'some string\'',
          '\'some string\': \'some string\'',
        ],
        messages: [
          'Prefer trailing comma.',
          'Prefer trailing comma.',
          'Prefer trailing comma.',
          'Prefer trailing comma.',
          'Prefer trailing comma.',
          'Prefer trailing comma.',
          'Prefer trailing comma.',
          'Prefer trailing comma.',
          'Prefer trailing comma.',
        ],
      );
    });
  });
}
