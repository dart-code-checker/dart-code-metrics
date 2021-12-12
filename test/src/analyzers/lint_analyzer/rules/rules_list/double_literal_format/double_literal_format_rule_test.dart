import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/double_literal_format/double_literal_format_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'double_literal_format/examples/example.dart';

void main() {
  group('DoubleLiteralFormatRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = DoubleLiteralFormatRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'double-literal-format',
        severity: Severity.style,
      );
    });

    test('report about found issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = DoubleLiteralFormatRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [4, 6, 8, 10, 15, 17, 19, 21, 26, 28, 30, 32],
        startColumns: [5, 5, 6, 6, 5, 5, 6, 6, 5, 5, 6, 6],
        locationTexts: [
          '05.23',
          '003.6e+5',
          '012.2',
          '001.1e-1',
          '.257',
          '.16e+5',
          '.259',
          '.14e-5',
          '0.2100',
          '0.100e+5',
          '0.2500',
          '0.400e-5',
        ],
        messages: [
          "Double literal shouldn't have redundant leading '0'.",
          "Double literal shouldn't have redundant leading '0'.",
          "Double literal shouldn't have redundant leading '0'.",
          "Double literal shouldn't have redundant leading '0'.",
          "Double literal shouldn't begin with '.'.",
          "Double literal shouldn't begin with '.'.",
          "Double literal shouldn't begin with '.'.",
          "Double literal shouldn't begin with '.'.",
          "Double literal shouldn't have a trailing '0'.",
          "Double literal shouldn't have a trailing '0'.",
          "Double literal shouldn't have a trailing '0'.",
          "Double literal shouldn't have a trailing '0'.",
        ],
        replacements: [
          '5.23',
          '3.6e+5',
          '12.2',
          '1.1e-1',
          '0.257',
          '0.16e+5',
          '0.259',
          '0.14e-5',
          '0.21',
          '0.1e+5',
          '0.25',
          '0.4e-5',
        ],
        replacementComments: [
          "Remove redundant leading '0'.",
          "Remove redundant leading '0'.",
          "Remove redundant leading '0'.",
          "Remove redundant leading '0'.",
          "Add missing leading '0'.",
          "Add missing leading '0'.",
          "Add missing leading '0'.",
          "Add missing leading '0'.",
          "Remove redundant trailing '0'.",
          "Remove redundant trailing '0'.",
          "Remove redundant trailing '0'.",
          "Remove redundant trailing '0'.",
        ],
      );
    });
  });
}
