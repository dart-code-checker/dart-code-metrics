import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/format_comment/format_comment_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'format_comment/examples/example.dart';
const _withoutIssuePath = 'format_comment/examples/example_without_issue.dart';
const _multiline = 'format_comment/examples/example_documentation.dart';

void main() {
  group('FormatCommentRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = FormatCommentRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'format-comment',
        severity: Severity.style,
      );
    });

    test('reports about found issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = FormatCommentRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [1, 3, 5, 8, 10],
        startColumns: [1, 3, 5, 3, 5],
        locationTexts: [
          '// With start space without dot',
          '//Without start space without dot',
          '// with start space with dot.',
          '/// With start space without dot',
          '/// with start space with dot.',
        ],
        messages: [
          'Prefer formatting comments like sentences.',
          'Prefer formatting comments like sentences.',
          'Prefer formatting comments like sentences.',
          'Prefer formatting comments like sentences.',
          'Prefer formatting comments like sentences.',
        ],
        replacements: [
          '// With start space without dot.',
          '// Without start space without dot.',
          '// With start space with dot.',
          '/// With start space without dot.',
          '/// With start space with dot.',
        ],
      );
    });

    test('reports about found issues in cases from documentation', () async {
      final unit = await RuleTestHelper.resolveFromFile(_multiline);
      final issues = FormatCommentRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [2, 5, 9, 13, 17],
        startColumns: [3, 3, 1, 3, 1],
        locationTexts: [
          '/// The value this wraps',
          '/// true if this box contains a value.',
          '//not if there is nothing before it',
          '// assume we have a valid name.',
          '/// deletes the file at [path] from the file system.',
        ],
        messages: [
          'Prefer formatting comments like sentences.',
          'Prefer formatting comments like sentences.',
          'Prefer formatting comments like sentences.',
          'Prefer formatting comments like sentences.',
          'Prefer formatting comments like sentences.',
        ],
        replacements: [
          '/// The value this wraps.',
          '/// True if this box contains a value.',
          '// Not if there is nothing before it.',
          '// Assume we have a valid name.',
          '/// Deletes the file at [path] from the file system.',
        ],
      );
    });

    test('reports no issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_withoutIssuePath);
      RuleTestHelper.verifyNoIssues(FormatCommentRule().check(unit));
    });
  });
}
