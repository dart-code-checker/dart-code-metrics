@TestOn('vm')
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/capitalize_comment/capitalize_comment_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'capitalize_comment/examples/example.dart';

void main() {
  group('CapitalizeCommentRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = CapitalizeCommentRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'capitalize-comment',
        severity: Severity.warning,
      );
    });

    test('reports about found issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = CapitalizeCommentRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        locationTexts: [],
        messages: [],
      );
    });
  });
}
