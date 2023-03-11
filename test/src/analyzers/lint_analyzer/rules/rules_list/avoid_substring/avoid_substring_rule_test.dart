import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/avoid_substring/avoid_substring_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'avoid_substring/examples/example.dart';

void main() {
  group('AvoidSubstringRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = AvoidSubstringRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'avoid-substring',
        severity: Severity.warning,
      );
    });

    test('reports about found issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = AvoidSubstringRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [3, 5],
        startColumns: [3, 3],
        locationTexts: [
          's.substring(14, 15)',
          '''"It's a smiley 😀 smile".substring(14, 15)''',
        ],
        messages: [
          'Avoid using substring if you are having emojis in the string. Consider using characters.getRange instead.',
          'Avoid using substring if you are having emojis in the string. Consider using characters.getRange instead.',
        ],
      );
    });
  });
}
