import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/tag_name/tag_name_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'tag_name/examples/example.dart';

void main() {
  group('TagNameRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = TagNameRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'tag-name',
        severity: Severity.warning,
      );
    });

    test('reports about found issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = TagNameRule({
        'var-names': ['_kTag', 'tag', 'TAG'],
        'strip-prefix': '_',
        'strip-postfix': 'State',
      }).check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [6],
        startColumns: [24],
        locationTexts: ["'Orange'"],
        messages: ['Tag name should match class name'],
        replacements: ["'Apple'"],
        replacementComments: ["Replace with 'Apple'"],
      );
    });
  });
}
