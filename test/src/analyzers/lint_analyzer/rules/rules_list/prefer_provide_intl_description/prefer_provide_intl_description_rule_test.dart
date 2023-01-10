import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/prefer_provide_intl_description/prefer_provide_intl_description_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'prefer_provide_intl_description/examples/example.dart';
const _incorrectExamplePath =
    'prefer_provide_intl_description/examples/incorrect_example.dart';

void main() {
  group('$PreferProvideIntlDescriptionRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_incorrectExamplePath);
      final issues = PreferProvideIntlDescriptionRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'prefer-provide-intl-description',
        severity: Severity.warning,
      );
    });

    test('reports no issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = PreferProvideIntlDescriptionRule().check(unit);

      RuleTestHelper.verifyNoIssues(issues);
    });

    test('reports about found issues for incorrect names', () async {
      final unit = await RuleTestHelper.resolveFromFile(_incorrectExamplePath);
      final issues = PreferProvideIntlDescriptionRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [2, 8, 13, 21, 28, 37, 45, 52],
        startColumns: [33, 34, 26, 27, 26, 27, 26, 27],
        locationTexts: [
          'Intl.message(\n'
              "    'message',\n"
              "    name: 'SomeClassI18n_message',\n"
              "    desc: '',\n"
              '  )',
          'Intl.message(\n'
              "    'message2',\n"
              "    name: 'SomeClassI18n_message2',\n"
              '  )',
          'Intl.plural(\n'
              '    1,\n'
              "    one: 'one',\n"
              "    other: 'other',\n"
              "    name: 'SomeClassI18n_plural',\n"
              "    desc: '',\n"
              '  )',
          'Intl.plural(\n'
              '    2,\n'
              "    one: 'one',\n"
              "    other: 'other',\n"
              "    name: 'SomeClassI18n_plural2',\n"
              '  )',
          'Intl.gender(\n'
              "    'other',\n"
              "    female: 'female',\n"
              "    male: 'male',\n"
              "    other: 'other',\n"
              "    name: 'SomeClassI18n_gender',\n"
              "    desc: '',\n"
              '  )',
          'Intl.gender(\n'
              "    'other',\n"
              "    female: 'female',\n"
              "    male: 'male',\n"
              "    other: 'other',\n"
              "    name: 'SomeClassI18n_gender2',\n"
              '  )',
          'Intl.select(\n'
              '    true,\n'
              "    {true: 'true', false: 'false'},\n"
              "    name: 'SomeClassI18n_select',\n"
              "    desc: '',\n"
              '  )',
          'Intl.select(\n'
              '    false,\n'
              "    {true: 'true', false: 'false'},\n"
              "    name: 'SomeClassI18n_select',\n"
              '  )',
        ],
        messages: List.filled(
          issues.length,
          'Provide description for translated message',
        ),
      );
    });
  });
}
