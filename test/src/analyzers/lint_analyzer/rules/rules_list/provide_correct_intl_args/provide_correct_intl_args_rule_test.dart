import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/provide_correct_intl_args/provide_correct_intl_args_rule.dart';
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
