import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/prefer_using_list_view/prefer_using_list_view_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'prefer_using_list_view/examples/example.dart';

void main() {
  group(
    'PreferUsingListViewRule',
    () {
      test('initialization', () async {
        final unit = await RuleTestHelper.resolveFromFile(_examplePath);
        final issues = PreferUsingListViewRule().check(unit);

        RuleTestHelper.verifyInitialization(
          issues: issues,
          ruleId: 'prefer-using-list-view',
          severity: Severity.performance,
        );
      });

      test('reports about found issues', () async {
        final unit = await RuleTestHelper.resolveFromFile(_examplePath);
        final issues = PreferUsingListViewRule().check(unit);

        RuleTestHelper.verifyIssues(
          issues: issues,
          startLines: [9],
          startColumns: [12],
          locationTexts: [
            'SingleChildScrollView(\n'
                '      child: Column(\n'
                '        children: [\n'
                "          Text('Wow lint rule'),\n"
                "          Text('Wow another lint rule'),\n"
                '        ],\n'
                '      ),\n'
                '    )',
          ],
          messages: [
            'Preferred to use ListView instead of the combo SingleChildScrollView and Column.',
          ],
        );
      });
    },
  );
}
