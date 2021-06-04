@TestOn('vm')
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/provide_correct_intl_args/provide_correct_intl_args.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'provide_correct_intl_args/examples/example.dart';
const _incorrectExamplePath =
    'provide_correct_intl_args/examples/incorrect_example.dart';

void main() {
  group('ProvideCorrectIntlArgsRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = ProvideCorrectIntlArgsRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'provide-correct-intl-args',
        severity: Severity.warning,
      );
    });

    test('reports no issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = ProvideCorrectIntlArgsRule().check(unit);

      RuleTestHelper.verifyNoIssues(issues);
    });

    test('reports about found issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_incorrectExamplePath);
      final issues = ProvideCorrectIntlArgsRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startOffsets: [
          184,
          192,
          192,
          192,
          504,
          505,
          403,
          700,
          701,
          916,
          1256,
          1587,
          1443,
          1484,
          1690,
          1744,
          2073,
          1966,
          2175,
          2229,
          2580,
          2464,
        ],
        startLines: [
          8,
          8,
          8,
          8,
          18,
          18,
          16,
          24,
          24,
          30,
          40,
          49,
          46,
          47,
          53,
          54,
          62,
          60,
          66,
          67,
          75,
          73,
        ],
        startColumns: [
          45,
          53,
          53,
          53,
          15,
          16,
          33,
          15,
          16,
          23,
          34,
          16,
          56,
          33,
          68,
          47,
          23,
          47,
          72,
          47,
          23,
          47,
        ],
        endOffsets: [
          197,
          196,
          196,
          196,
          510,
          509,
          407,
          706,
          705,
          920,
          1265,
          1596,
          1448,
          1489,
          1694,
          1748,
          2077,
          1970,
          2179,
          2233,
          2584,
          2468,
        ],
        locationTexts: [
          '(String name)',
          'name',
          'name',
          'name',
          '[name]',
          'name',
          'name',
          '[name]',
          'name',
          'name',
          'value + 1',
          'value + 1',
          'value',
          'value',
          'name',
          'name',
          'name',
          'name',
          'name',
          'name',
          'name',
          'name',
        ],
        messages: [
          'Parameter "args" should be added',
          'Parameter should be added to args',
          'Parameter is unused and should be removed',
          'Item is unused and should be removed',
          'Parameter "args" should be removed',
          'Args item should be added to parameters',
          'Interpolation expression should be added to parameters',
          'Parameter "args" should be removed',
          'Args item should be added to parameters',
          'Args item should be added to parameters',
          'Item should be simple identifier',
          'Item should be simple identifier',
          'Parameter should be added to args',
          'Interpolation expression should be added to args',
          'Parameter should be added to args',
          'Interpolation expression should be added to args',
          'Args item should be added to parameters',
          'Interpolation expression should be added to parameters',
          'Parameter should be added to args',
          'Interpolation expression should be added to args',
          'Args item should be added to parameters',
          'Interpolation expression should be added to parameters',
        ],
      );
    });
  });
}
