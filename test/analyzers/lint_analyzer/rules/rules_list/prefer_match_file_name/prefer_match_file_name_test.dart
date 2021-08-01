@TestOn('vm')
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/prefer_match_file_name/prefer_match_file_name.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'prefer_match_file_name/examples/example.dart';
const _exampleWithStatePath =
    'prefer_match_file_name/examples/example_with_state.dart';
const _exampleWithIssue =
    'prefer_match_file_name/examples/example_with_issue.dart';

void main() {
  group('PreferMatchFileName', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = PreferMatchFileName().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'prefer_match_file_name',
        severity: Severity.style,
      );
    });
    group('test rule', () {
      test('not found issue', () async {
        final unit = await RuleTestHelper.resolveFromFile(_examplePath);
        final issues = PreferMatchFileName().check(unit);

        RuleTestHelper.verifyNoIssues(issues);
      });

      test('reports about found issues', () async {
        final unit = await RuleTestHelper.resolveFromFile(_exampleWithIssue);
        final issues = PreferMatchFileName().check(unit);

        RuleTestHelper.verifyIssues(issues: issues);
      });

      test('not found issue', () async {
        final unit =
            await RuleTestHelper.resolveFromFile(_exampleWithStatePath);
        final issues = PreferMatchFileName().check(unit);

        RuleTestHelper.verifyNoIssues(issues);
      });
    });
  });
}
