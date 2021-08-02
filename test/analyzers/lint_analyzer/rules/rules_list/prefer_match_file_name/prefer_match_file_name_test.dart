@TestOn('vm')
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/prefer_match_file_name/prefer_match_file_name.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'prefer_match_file_name/examples';
const _withSingleClass = '$_examplePath/example.dart';
const _withStateFullWidget = '$_examplePath/example_with_state.dart';
const _withIssue = '$_examplePath/example_with_issue.dart';
const _emptyFile = '$_examplePath/empty_file.dart';

void main() {
  group('PreferMatchFileName', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_withSingleClass);
      final issues = PreferMatchFileName().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'prefer_match_file_name',
        severity: Severity.style,
      );
    });
    group('test rule', () {
      test('not found issue', () async {
        final unit = await RuleTestHelper.resolveFromFile(_withSingleClass);
        final issues = PreferMatchFileName().check(unit);

        RuleTestHelper.verifyNoIssues(issues);
      });

      test('reports about found issues', () async {
        final unit = await RuleTestHelper.resolveFromFile(_withIssue);
        final issues = PreferMatchFileName().check(unit);

        RuleTestHelper.verifyIssues(issues: issues);
      });

      test('Checking a class with a stateful widget.', () async {
        final unit = await RuleTestHelper.resolveFromFile(_withStateFullWidget);
        final issues = PreferMatchFileName().check(unit);

        RuleTestHelper.verifyNoIssues(issues);
      });

      test('Checking an empty file. The error must not be found.', () async {
        final unit = await RuleTestHelper.resolveFromFile(_emptyFile);
        final issues = PreferMatchFileName().check(unit);

        RuleTestHelper.verifyNoIssues(issues);
      });
    });
  });
}
