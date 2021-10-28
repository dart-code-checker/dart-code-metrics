@TestOn('vm')
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/prefer_trailing_comma/prefer_trailing_comma.dart';
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
        severity: Severity.warning,
      );
    });

    test('with default config reports about found issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_incorrectExamplePath);
      final issues = PreferTrailingCommaRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startOffsets: [
          77,
          196,
          333,
          457,
          582,
          691,
          813,
          1039,
          1218,
          1331,
          1471,
        ],
        startLines: [3, 9, 13, 18, 24, 28, 38, 49, 58, 64, 70],
        startColumns: [50, 7, 5, 52, 9, 8, 3, 59, 3, 3, 3],
        endOffsets: [97, 234, 344, 477, 620, 710, 822, 1054, 1256, 1369, 1549],
        locationTexts: [
          'String thirdArgument',
          "'and another string for length exceed'",
          'String arg3',
          'String thirdArgument',
          "'and another string for length exceed'",
          "'some other string'",
          'sixthItem',
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
          'Add trailing comma.',
        ],
        replacements: [
          'String thirdArgument,',
          "'and another string for length exceed',",
          'String arg3,',
          'String thirdArgument,',
          "'and another string for length exceed',",
          "'some other string',",
          'sixthItem,',
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
        startOffsets: [130, 226, 275, 610, 656, 1002, 1287, 1370, 1553, 1732],
        startLines: [9, 17, 19, 37, 41, 75, 91, 99, 109, 119],
        startColumns: [21, 33, 20, 23, 19, 18, 43, 21, 19, 19],
        endOffsets: [141, 250, 299, 634, 680, 1011, 1288, 1383, 1566, 1760],
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
          'firstItem',
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
          'Prefer trailing comma.',
        ],
      );
    });
  });
}
