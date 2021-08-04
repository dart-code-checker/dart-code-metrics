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
const _privateClass = '$_examplePath/private_class.dart';
const _multiClass = '$_examplePath/multiple_classes_example.dart';

void main() {
  group('PreferMatchFileName', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_withSingleClass);
      final issues = PreferMatchFileName().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'prefer-match-file-name',
        severity: Severity.style,
      );
    });

    test('reports no issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_withSingleClass);
      final issues = PreferMatchFileName().check(unit);

      RuleTestHelper.verifyNoIssues(issues);
    });

    test('reports about found issues for incorrect class name', () async {
      final unit = await RuleTestHelper.resolveFromFile(_withIssue);
      final issues = PreferMatchFileName().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startOffsets: [6],
        startLines: [1],
        startColumns: [7],
        endOffsets: [13],
        messages: ['File name does not match with first class name'],
        locationTexts: ['Example'],
      );
    });

    test('reports no issues for statefull widget class', () async {
      final unit = await RuleTestHelper.resolveFromFile(_withStateFullWidget);
      final issues = PreferMatchFileName().check(unit);

      RuleTestHelper.verifyNoIssues(issues);
    });

    test('reports no issues for empty file', () async {
      final unit = await RuleTestHelper.resolveFromFile(_emptyFile);
      final issues = PreferMatchFileName().check(unit);

      RuleTestHelper.verifyNoIssues(issues);
    });

    test('reports no issues for file with only private class', () async {
      final unit = await RuleTestHelper.resolveFromFile(_privateClass);
      final issues = PreferMatchFileName().check(unit);

      RuleTestHelper.verifyNoIssues(issues);
    });

    test('reports no issues for file multiples file', () async {
      final unit = await RuleTestHelper.resolveFromFile(_multiClass);
      final issues = PreferMatchFileName().check(unit);

      RuleTestHelper.verifyNoIssues(issues);
    });
  });
}
