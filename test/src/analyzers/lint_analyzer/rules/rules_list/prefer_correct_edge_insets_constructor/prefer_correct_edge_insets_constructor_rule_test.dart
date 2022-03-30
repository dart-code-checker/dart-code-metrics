import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/prefer_correct_edge_insets_constructor/prefer_correct_edge_insets_constructor_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _path = 'prefer_correct_edge_insets_constructor/examples';
const _exampleOnly = '$_path/example_only.dart';
const _exampleSymmetric = '$_path/example_symmetric.dart';
const _exampleLTRB = '$_path/example_ltrb.dart';

void main() {
  group(
    'PreferCorrectEdgeInsetsConstructorRule',
    () {
      test('initialization', () async {
        final unit = await RuleTestHelper.resolveFromFile(_exampleOnly);
        final issues = PreferCorrectEdgeInsetsConstructorRule().check(unit);

        RuleTestHelper.verifyInitialization(
          issues: issues,
          ruleId: 'prefer-correct-edge-insets-constructor',
          severity: Severity.style,
        );
      });

      test('reports about found issues in only constructor', () async {
        final unit = await RuleTestHelper.resolveFromFile(_exampleOnly);
        final issues = PreferCorrectEdgeInsetsConstructorRule().check(unit);

        RuleTestHelper.verifyIssues(
          issues: issues,
          startLines: [6, 14, 18, 22, 25, 28, 36, 44, 52, 55],
          startColumns: [20, 20, 20, 20, 20, 20, 20, 20, 20, 20],
          messages: [
            'Prefer using correct EdgeInsets constructor.',
            'Prefer using correct EdgeInsets constructor.',
            'Prefer using correct EdgeInsets constructor.',
            'Prefer using correct EdgeInsets constructor.',
            'Prefer using correct EdgeInsets constructor.',
            'Prefer using correct EdgeInsets constructor.',
            'Prefer using correct EdgeInsets constructor.',
            'Prefer using correct EdgeInsets constructor.',
            'Prefer using correct EdgeInsets constructor.',
            'Prefer using correct EdgeInsets constructor.',
          ],
          replacementComments: [
            'Prefer use EdgeInsets.symmetric(horizontal: 5, vertical: 10)',
            'Prefer use EdgeInsets.all(10)',
            'Prefer use EdgeInsets.symmetric(horizontal: 12, vertical: 10)',
            'Prefer use EdgeInsets.symmetric(vertical: 10)',
            'Prefer use EdgeInsets.symmetric(horizontal: 10)',
            'Prefer use EdgeInsets.symmetric(horizontal: 5, vertical: 10)',
            'Prefer use EdgeInsets.all(10.0)',
            'Prefer use EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0)',
            'Prefer use EdgeInsets.symmetric(vertical: 10.0)',
            'Prefer use EdgeInsets.symmetric(horizontal: 10.0)',
          ],
          replacements: [
            'EdgeInsets.symmetric(horizontal: 5, vertical: 10)',
            'EdgeInsets.all(10)',
            'EdgeInsets.symmetric(horizontal: 12, vertical: 10)',
            'EdgeInsets.symmetric(vertical: 10)',
            'EdgeInsets.symmetric(horizontal: 10)',
            'EdgeInsets.symmetric(horizontal: 5, vertical: 10)',
            'EdgeInsets.all(10.0)',
            'EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0)',
            'EdgeInsets.symmetric(vertical: 10.0)',
            'EdgeInsets.symmetric(horizontal: 10.0)',
          ],
          locationTexts: [
            'const EdgeInsets.only(\n'
                '            top: 10,\n'
                '            left: 5,\n'
                '            bottom: 10,\n'
                '            right: 5,\n'
                '          )',
            'const EdgeInsets.only(\n'
                '              bottom: 10, right: 10, left: 10, top: 10)',
            'const EdgeInsets.only(\n'
                '              bottom: 10, right: 12, left: 12, top: 10)',
            'const EdgeInsets.only(bottom: 10, top: 10)',
            'const EdgeInsets.only(left: 10, right: 10)',
            'const EdgeInsets.only(\n'
                '            top: 10,\n'
                '            left: 5,\n'
                '            bottom: 10,\n'
                '            right: 5,\n'
                '          )',
            'const EdgeInsets.only(\n'
                '            bottom: 10.0,\n'
                '            right: 10.0,\n'
                '            left: 10.0,\n'
                '            top: 10.0,\n'
                '          )',
            'const EdgeInsets.only(\n'
                '            bottom: 10.0,\n'
                '            right: 12.0,\n'
                '            left: 12.0,\n'
                '            top: 10.0,\n'
                '          )',
            'const EdgeInsets.only(bottom: 10.0, top: 10.0)',
            'const EdgeInsets.only(left: 10.0, right: 10.0)',
          ],
        );
      });

      test('reports about found issues in ltrb constructor', () async {
        final unit = await RuleTestHelper.resolveFromFile(_exampleLTRB);
        final issues = PreferCorrectEdgeInsetsConstructorRule().check(unit);

        RuleTestHelper.verifyIssues(
          issues: issues,
          startLines: [6, 9, 12, 15, 18, 24, 27, 30, 33, 36, 42],
          startColumns: [20, 20, 20, 20, 20, 20, 20, 20, 20, 20, 20],
          messages: [
            'Prefer using correct EdgeInsets constructor.',
            'Prefer using correct EdgeInsets constructor.',
            'Prefer using correct EdgeInsets constructor.',
            'Prefer using correct EdgeInsets constructor.',
            'Prefer using correct EdgeInsets constructor.',
            'Prefer using correct EdgeInsets constructor.',
            'Prefer using correct EdgeInsets constructor.',
            'Prefer using correct EdgeInsets constructor.',
            'Prefer using correct EdgeInsets constructor.',
            'Prefer using correct EdgeInsets constructor.',
            'Prefer using correct EdgeInsets constructor.',
          ],
          replacementComments: [
            'Prefer use EdgeInsets.only(left: 1, top: 1)',
            'Prefer use EdgeInsets.all(12)',
            'Prefer use EdgeInsets.all(1)',
            'Prefer use EdgeInsets.symmetric(horizontal: 3, vertical: 2)',
            'Prefer use EdgeInsets.only(left: 3, bottom: 2)',
            'Prefer use EdgeInsets.only(left: 1.0, top: 1.0)',
            'Prefer use EdgeInsets.all(12.0)',
            'Prefer use EdgeInsets.all(1.0)',
            'Prefer use EdgeInsets.symmetric(horizontal: 3.0, vertical: 2.0)',
            'Prefer use EdgeInsets.only(left: 3.0, bottom: 2.0)',
            'Prefer use EdgeInsets.zero',
          ],
          replacements: [
            'EdgeInsets.only(left: 1, top: 1)',
            'EdgeInsets.all(12)',
            'EdgeInsets.all(1)',
            'EdgeInsets.symmetric(horizontal: 3, vertical: 2)',
            'EdgeInsets.only(left: 3, bottom: 2)',
            'EdgeInsets.only(left: 1.0, top: 1.0)',
            'EdgeInsets.all(12.0)',
            'EdgeInsets.all(1.0)',
            'EdgeInsets.symmetric(horizontal: 3.0, vertical: 2.0)',
            'EdgeInsets.only(left: 3.0, bottom: 2.0)',
            'EdgeInsets.zero',
          ],
          locationTexts: [
            'const EdgeInsets.fromLTRB(1, 1, 0, 0)',
            'const EdgeInsets.fromLTRB(12, 12, 12, 12)',
            'const EdgeInsets.fromLTRB(1, 1, 1, 1)',
            'const EdgeInsets.fromLTRB(3, 2, 3, 2)',
            'const EdgeInsets.fromLTRB(3, 0, 0, 2)',
            'const EdgeInsets.fromLTRB(1.0, 1.0, 0.0, 0.0)',
            'const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 12.0)',
            'const EdgeInsets.fromLTRB(1.0, 1.0, 1.0, 1.0)',
            'const EdgeInsets.fromLTRB(3.0, 2.0, 3.0, 2.0)',
            'const EdgeInsets.fromLTRB(3.0, 0.0, 0.0, 2.0)',
            'const EdgeInsets.fromLTRB(0, 0, 0, 0)',
          ],
        );
      });

      test('reports about found issues in symmetric constructor', () async {
        final unit = await RuleTestHelper.resolveFromFile(_exampleSymmetric);
        final issues = PreferCorrectEdgeInsetsConstructorRule().check(unit);

        RuleTestHelper.verifyIssues(
          issues: issues,
          startLines: [7, 11, 15, 18, 22, 26],
          startColumns: [15, 15, 15, 20, 20, 20],
          messages: [
            'Prefer using correct EdgeInsets constructor.',
            'Prefer using correct EdgeInsets constructor.',
            'Prefer using correct EdgeInsets constructor.',
            'Prefer using correct EdgeInsets constructor.',
            'Prefer using correct EdgeInsets constructor.',
            'Prefer using correct EdgeInsets constructor.',
          ],
          replacementComments: [
            'Prefer use EdgeInsets.all(10)',
            'Prefer use EdgeInsets.symmetric(horizontal: 10)',
            'Prefer use EdgeInsets.symmetric(vertical: 10)',
            'Prefer use EdgeInsets.all(10.0)',
            'Prefer use EdgeInsets.symmetric(horizontal: 10.0)',
            'Prefer use EdgeInsets.symmetric(vertical: 10.0)',
          ],
          replacements: [
            'EdgeInsets.all(10)',
            'EdgeInsets.symmetric(horizontal: 10)',
            'EdgeInsets.symmetric(vertical: 10)',
            'EdgeInsets.all(10.0)',
            'EdgeInsets.symmetric(horizontal: 10.0)',
            'EdgeInsets.symmetric(vertical: 10.0)',
          ],
          locationTexts: [
            'const EdgeInsets.symmetric(horizontal: 10, vertical: 10)',
            'const EdgeInsets.symmetric(horizontal: 10, vertical: 0)',
            'const EdgeInsets.symmetric(horizontal: 0, vertical: 10)',
            'const EdgeInsets.symmetric(\n'
                '              horizontal: 10.0, vertical: 10.0)',
            'const EdgeInsets.symmetric(\n'
                '              horizontal: 10.0, vertical: 0.0)',
            'const EdgeInsets.symmetric(\n'
                '            horizontal: 0.0,\n'
                '            vertical: 10.0,\n'
                '          )',
          ],
        );
      });
    },
  );
}
