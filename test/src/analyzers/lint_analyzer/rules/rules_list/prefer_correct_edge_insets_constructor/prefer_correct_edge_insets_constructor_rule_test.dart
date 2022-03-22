import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/prefer_correct_edge_insets_constructor/prefer_correct_edge_insets_constructor_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath =
    'prefer_correct_edge_insets_constructor/examples/example.dart';

void main() {
  group(
    'PreferCorrectEdgeInsetsConstructorRule',
    () {
      test('initialization', () async {
        final unit = await RuleTestHelper.resolveFromFile(_examplePath);
        final issues = PreferCorrectEdgeInsetsConstructorRule().check(unit);

        RuleTestHelper.verifyInitialization(
          issues: issues,
          ruleId: 'prefer-correct-edge-insets-constructor-rule',
          severity: Severity.style,
        );
      });

      test('reports about found issues', () async {
        final unit = await RuleTestHelper.resolveFromFile(_examplePath);
        final issues = PreferCorrectEdgeInsetsConstructorRule().check(unit);

        RuleTestHelper.verifyIssues(
          issues: issues,
          startLines: [4, 7, 11, 14, 18],
          startColumns: [20, 20, 15, 20, 20],
          messages: [
            'Prefer using correct EdgeInsets constructor.',
            'Prefer using correct EdgeInsets constructor.',
            'Prefer using correct EdgeInsets constructor.',
            'Prefer using correct EdgeInsets constructor.',
            'Prefer using correct EdgeInsets constructor.',
          ],
          replacementComments: [
            'Prefer use EdgeInsets.only(left: 1, top: 1)',
            'Prefer use EdgeInsets.all(1)',
            'Prefer use EdgeInsets.all(10)',
            'Prefer use EdgeInsets.zero',
            'Prefer use EdgeInsets.symmetric(horizontal: 5, vertical: 10)',
          ],
          replacements: [
            'EdgeInsets.only(left: 1, top: 1)',
            'EdgeInsets.all(1)',
            'EdgeInsets.all(10)',
            'EdgeInsets.zero',
            'EdgeInsets.symmetric(horizontal: 5, vertical: 10)',
          ],
          locationTexts: [
            'const EdgeInsets.fromLTRB(1, 1, 0, 0)',
            'const EdgeInsets.fromLTRB(1, 1, 1, 1)',
            'const EdgeInsets.symmetric(horizontal: 10, vertical: 10)',
            'const EdgeInsets.only(\n'
                '              top: 0, left: 0, bottom: 0, right: 0)',
            'const EdgeInsets.only(\n'
                '              top: 10, left: 5, bottom: 10, right: 5)',
          ],
        );
      });
    },
  );
}
