import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/format_comment/format_comment_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'format_comment/examples/example.dart';
const _withoutIssuePath = 'format_comment/examples/example_without_issue.dart';
const _documentationExamplePath =
    'format_comment/examples/example_documentation.dart';
const _multilineExamplePath = 'format_comment/examples/multiline_example.dart';

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
        startLines: [1, 3, 5, 10, 8],
        startColumns: [1, 3, 5, 5, 3],
        locationTexts: [
          '// With start space without dot',
          '//Without start space without dot',
          '// with start space with dot.',
          '//Any other comment',
          '/// With start space without dot',
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
          '// Any other comment.',
          '/// With start space without dot.',
        ],
        replacementComments: [
          'Format comment.',
          'Format comment.',
          'Format comment.',
          'Format comment.',
          'Format comment.',
        ],
      );
    });

    test('reports about found issues in cases from documentation', () async {
      final unit =
          await RuleTestHelper.resolveFromFile(_documentationExamplePath);
      final issues = FormatCommentRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [9, 13, 2, 5, 17],
        startColumns: [1, 3, 3, 3, 1],
        locationTexts: [
          '//not if there is nothing before it',
          '// assume we have a valid name.',
          '/// The value this wraps',
          '/// true if this box contains a value.',
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
          '// Not if there is nothing before it.',
          '// Assume we have a valid name.',
          '/// The value this wraps.',
          '/// True if this box contains a value.',
          '/// Deletes the file at [path] from the file system.',
        ],
        replacementComments: [
          'Format comment.',
          'Format comment.',
          'Format comment.',
          'Format comment.',
          'Format comment.',
        ],
      );
    });

    test('reports about found issues only for doc comments', () async {
      final unit =
          await RuleTestHelper.resolveFromFile(_documentationExamplePath);
      final issues = FormatCommentRule(const {
        'only-doc-comments': true,
      }).check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [2, 5, 17],
        startColumns: [3, 3, 1],
        locationTexts: [
          '/// The value this wraps',
          '/// true if this box contains a value.',
          '/// deletes the file at [path] from the file system.',
        ],
        messages: [
          'Prefer formatting comments like sentences.',
          'Prefer formatting comments like sentences.',
          'Prefer formatting comments like sentences.',
        ],
        replacements: [
          '/// The value this wraps.',
          '/// True if this box contains a value.',
          '/// Deletes the file at [path] from the file system.',
        ],
        replacementComments: [
          'Format comment.',
          'Format comment.',
          'Format comment.',
        ],
      );
    });

    test('reports about found issues for multiline comments', () async {
      final unit = await RuleTestHelper.resolveFromFile(_multilineExamplePath);
      final issues = FormatCommentRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [33, 34, 37, 38, 39, 40, 51, 30],
        startColumns: [5, 5, 3, 3, 3, 3, 3, 3],
        locationTexts: [
          '// with start space with dot.',
          '// some text',
          '// not',
          '// a',
          '// sentence',
          '// at all',
          '//Some wrong comment',
          '/// whether [_enclosingClass] and [_enclosingExecutable] have been\n'
              '  /// initialized.',
        ],
        messages: [
          'Prefer formatting comments like sentences.',
          'Prefer formatting comments like sentences.',
          'Prefer formatting comments like sentences.',
          'Prefer formatting comments like sentences.',
          'Prefer formatting comments like sentences.',
          'Prefer formatting comments like sentences.',
          'Prefer formatting comments like sentences.',
          'Prefer formatting comments like sentences.',
        ],
      );
    });

    test('reports no issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_withoutIssuePath);
      RuleTestHelper.verifyNoIssues(FormatCommentRule().check(unit));
    });

    test('ignores the given patterns', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = FormatCommentRule(const {
        'ignored-patterns': [
          // Ignores all the comments that start with 'Without'.
          r'^Without.*$',
        ],
      }).check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [1, 5, 10, 8],
        startColumns: [1, 5, 5, 3],
        locationTexts: [
          '// With start space without dot',
          '// with start space with dot.',
          '//Any other comment',
          '/// With start space without dot',
        ],
        messages: [
          'Prefer formatting comments like sentences.',
          'Prefer formatting comments like sentences.',
          'Prefer formatting comments like sentences.',
          'Prefer formatting comments like sentences.',
        ],
        replacements: [
          '// With start space without dot.',
          '// With start space with dot.',
          '// Any other comment.',
          '/// With start space without dot.',
        ],
        replacementComments: [
          'Format comment.',
          'Format comment.',
          'Format comment.',
          'Format comment.',
        ],
      );
    });
  });
}
