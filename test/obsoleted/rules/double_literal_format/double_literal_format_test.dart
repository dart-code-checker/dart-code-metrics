@TestOn('vm')
import 'package:dart_code_metrics/src/models/severity.dart';
import 'package:dart_code_metrics/src/obsoleted/rules/double_literal_format_rule.dart';
import 'package:test/test.dart';

import '../../../helpers/rule_test_helper.dart';

const _examplePath =
    'test/obsoleted/rules/double_literal_format/examples/example.dart';

void main() {
  group('DoubleLiteralFormatRule', () {
    group('util function', () {
      test('detectLeadingZero', () {
        expect(
          ['05.23', '5.23', '003.6e+5', '3.6e+5', '0.1'].map(detectLeadingZero),
          equals([true, false, true, false, false]),
        );
      });

      test('leadingZeroCorrection', () {
        expect(
          ['05.23', '5.23', '003.6e+5', '3.6e+5', '0.1']
              .map(leadingZeroCorrection),
          equals(['5.23', '5.23', '3.6e+5', '3.6e+5', '0.1']),
        );
      });

      test('detectLeadingDecimal', () {
        expect(
          ['.257', '0.257', '.16e+5', '0.16e+5'].map(detectLeadingDecimal),
          equals([true, false, true, false]),
        );
      });

      test('leadingDecimalCorrection', () {
        expect(
          ['.257', '0.257', '.16e+5', '0.16e+5'].map(leadingDecimalCorrection),
          equals(['0.257', '0.257', '0.16e+5', '0.16e+5']),
        );
      });

      test('detectTrailingZero', () {
        expect(
          ['0.2100', '0.21', '0.100e+5', '0.1e+5'].map(detectTrailingZero),
          equals([true, false, true, false]),
        );
      });

      test('trailingZeroCorrection', () {
        expect(
          ['0.2100', '0.21', '0.100e+5', '0.1e+5'].map(trailingZeroCorrection),
          equals(['0.21', '0.21', '0.1e+5', '0.1e+5']),
        );
      });
    });

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
        startOffsets: [30, 59, 94, 125, 178, 207, 241, 272, 324, 354, 389, 421],
        startLines: [3, 5, 7, 9, 14, 16, 18, 20, 25, 27, 29, 31],
        startColumns: [5, 5, 6, 6, 5, 5, 6, 6, 5, 5, 6, 6],
        endOffsets: [35, 67, 99, 133, 182, 213, 245, 278, 330, 362, 395, 429],
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
          "Remove redundant leading '0'",
          "Remove redundant leading '0'",
          "Remove redundant leading '0'",
          "Remove redundant leading '0'",
          "Add missing leading '0'",
          "Add missing leading '0'",
          "Add missing leading '0'",
          "Add missing leading '0'",
          "Remove redundant trailing '0'",
          "Remove redundant trailing '0'",
          "Remove redundant trailing '0'",
          "Remove redundant trailing '0'",
        ],
      );
    });
  });
}
