import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/prefer_define_hero_tag/prefer_define_hero_tag_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'prefer_define_hero_tag/examples/example.dart';

void main() {
  group(
    'PreferDefineHeroTagRule',
    () {
      test('initialization', () async {
        final unit = await RuleTestHelper.resolveFromFile(_examplePath);
        final issues = PreferDefineHeroTagRule().check(unit);

        RuleTestHelper.verifyInitialization(
          issues: issues,
          ruleId: 'prefer-define-hero-tag',
          severity: Severity.warning,
        );
      });

      test('reports about found issues', () async {
        final unit = await RuleTestHelper.resolveFromFile(_examplePath);
        final issues = PreferDefineHeroTagRule().check(unit);

        RuleTestHelper.verifyIssues(
          issues: issues,
          startLines: [6, 17, 29, 40, 102, 131],
          startColumns: [31, 31, 31, 31, 13, 24],
          messages: [
            'Prefer define heroTag property.',
            'Prefer define heroTag property.',
            'Prefer define heroTag property.',
            'Prefer define heroTag property.',
            'Prefer define heroTag property.',
            'Prefer define heroTag property.',
          ],
          locationTexts: [
            '''
FloatingActionButton(
          onPressed: () {},
        )''',
            '''
FloatingActionButton.extended(
          label: const Text('label'),
          onPressed: () {},
        )''',
            '''
FloatingActionButton.large(
          onPressed: () {},
        )''',
            '''
FloatingActionButton.small(
          onPressed: () {},
        )''',
            '''
CupertinoSliverNavigationBar(
              largeTitle: Text('Contacts'),
            )''',
            '''
CupertinoNavigationBar(
          middle: Text('CupertinoNavigationBar Sample'),
        )''',
          ],
        );
      });
    },
  );
}
