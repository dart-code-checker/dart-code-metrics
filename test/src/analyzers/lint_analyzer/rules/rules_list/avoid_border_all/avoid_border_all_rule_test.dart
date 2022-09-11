import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/avoid_border_all/avoid_border_all_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'avoid_border_all/examples/example.dart';
const _exampleWithVariablesPath =
    'avoid_border_all/examples/example_with_final_variables.dart';

void main() {
  group('AvoidBorderAllRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = AvoidBorderAllRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'avoid-border-all',
        severity: Severity.performance,
      );
    });

    test('reports about found issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = AvoidBorderAllRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [4, 6, 11, 17],
        startColumns: [27, 19, 19, 19],
        locationTexts: [
          'Border.all()',
          'Border.all(\n'
              '            color: const Color(0),\n'
              '          )',
          'Border.all(\n'
              '            color: const Color(0),\n'
              '            width: 1,\n'
              '          )',
          'Border.all(\n'
              '            color: const Color(0),\n'
              '            width: 1,\n'
              '            style: BorderStyle.none,\n'
              '          )',
        ],
        replacementComments: [
          'Replace with const Border.fromBorderSide.',
          'Replace with const Border.fromBorderSide.',
          'Replace with const Border.fromBorderSide.',
          'Replace with const Border.fromBorderSide.',
        ],
        replacements: [
          'const Border.fromBorderSide(BorderSide())',
          'const Border.fromBorderSide(BorderSide(color: const Color(0)))',
          'const Border.fromBorderSide(BorderSide(color: const Color(0), width: 1))',
          'const Border.fromBorderSide(BorderSide(color: const Color(0), width: 1, style: BorderStyle.none))',
        ],
        messages: [
          'Prefer using const constructor Border.fromBorderSide.',
          'Prefer using const constructor Border.fromBorderSide.',
          'Prefer using const constructor Border.fromBorderSide.',
          'Prefer using const constructor Border.fromBorderSide.',
        ],
      );
    });

    test(
      'does not report a issue when final variable is used as argument',
      () async {
        final unit =
            await RuleTestHelper.resolveFromFile(_exampleWithVariablesPath);
        final issues = AvoidBorderAllRule().check(unit);

        RuleTestHelper.verifyNoIssues(issues);
      },
    );
  });
}
