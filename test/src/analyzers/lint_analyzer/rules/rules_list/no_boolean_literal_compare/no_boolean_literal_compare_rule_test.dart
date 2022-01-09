import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/no_boolean_literal_compare/no_boolean_literal_compare_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'no_boolean_literal_compare/examples/example.dart';

void main() {
  group('NoBooleanLiteralCompareRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = NoBooleanLiteralCompareRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'no-boolean-literal-compare',
        severity: Severity.style,
      );
    });

    test('reports about found issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = NoBooleanLiteralCompareRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [6, 8, 10, 12, 14, 16, 22, 24, 27, 28, 38],
        startColumns: [11, 11, 11, 11, 7, 7, 11, 11, 25, 25, 34],
        locationTexts: [
          'a == true',
          'b != true',
          'true == c',
          'false != c',
          'e == true',
          'e != false',
          'exampleString.isEmpty == true',
          'true == exampleString.isEmpty',
          'value == false',
          'value != false',
          'value == true',
        ],
        messages: [
          'Comparing boolean values to boolean literals is unnecessary, as those expressions will result in booleans too. Just use the boolean values directly or negate them.',
          'Comparing boolean values to boolean literals is unnecessary, as those expressions will result in booleans too. Just use the boolean values directly or negate them.',
          'Comparing boolean values to boolean literals is unnecessary, as those expressions will result in booleans too. Just use the boolean values directly or negate them.',
          'Comparing boolean values to boolean literals is unnecessary, as those expressions will result in booleans too. Just use the boolean values directly or negate them.',
          'Comparing boolean values to boolean literals is unnecessary, as those expressions will result in booleans too. Just use the boolean values directly or negate them.',
          'Comparing boolean values to boolean literals is unnecessary, as those expressions will result in booleans too. Just use the boolean values directly or negate them.',
          'Comparing boolean values to boolean literals is unnecessary, as those expressions will result in booleans too. Just use the boolean values directly or negate them.',
          'Comparing boolean values to boolean literals is unnecessary, as those expressions will result in booleans too. Just use the boolean values directly or negate them.',
          'Comparing boolean values to boolean literals is unnecessary, as those expressions will result in booleans too. Just use the boolean values directly or negate them.',
          'Comparing boolean values to boolean literals is unnecessary, as those expressions will result in booleans too. Just use the boolean values directly or negate them.',
          'Comparing boolean values to boolean literals is unnecessary, as those expressions will result in booleans too. Just use the boolean values directly or negate them.',
        ],
        replacements: [
          'a',
          '!b',
          'c',
          'c',
          'e',
          'e',
          'exampleString.isEmpty',
          'exampleString.isEmpty',
          '!value',
          'value',
          'value',
        ],
        replacementComments: [
          'This expression is unnecessarily compared to a boolean. Just use it directly.',
          'This expression is unnecessarily compared to a boolean. Just negate it.',
          'This expression is unnecessarily compared to a boolean. Just use it directly.',
          'This expression is unnecessarily compared to a boolean. Just use it directly.',
          'This expression is unnecessarily compared to a boolean. Just use it directly.',
          'This expression is unnecessarily compared to a boolean. Just use it directly.',
          'This expression is unnecessarily compared to a boolean. Just use it directly.',
          'This expression is unnecessarily compared to a boolean. Just use it directly.',
          'This expression is unnecessarily compared to a boolean. Just negate it.',
          'This expression is unnecessarily compared to a boolean. Just use it directly.',
          'This expression is unnecessarily compared to a boolean. Just use it directly.',
        ],
      );
    });
  });
}
