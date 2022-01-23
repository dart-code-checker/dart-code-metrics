import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/format_comment/format_comment_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'format_comment/examples/example.dart';
const _withoutIssuePath = 'format_comment/examples/example_without_issue.dart';

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
        startLines: [1, 2, 3, 4, 6, 8, 11, 13, 24, 25, 26,28,29],
        startColumns: [1, 1, 1, 1, 3, 5, 3, 5, 1, 1, 1,1,1],
        locationTexts: [
          '// With start space without dot',
          '/* With start space without dot*/',
          '/*Without start space without dot*/',
          '/* with start space with dot.*/',
          '//Without start space without dot',
          '// with start space with dot.',
          '/// With start space without dot',
          '/// with start space with dot.',
          '//ignore_for_file',
          '//ignore',
          '/* with start space\n'
              'with dot.*/',
          '//Test multiline comment',
          '//second row',
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
          'Prefer formatting comments like sentences.',
          'Prefer formatting comments like sentences.',
          'Prefer formatting comments like sentences.',
          'Prefer formatting comments like sentences.',
          'Prefer formatting comments like sentences.',
        ],
        replacements: [
          '// With start space without dot.',
          '/* With start space without dot.*/',
          '/* Without start space without dot.*/',
          '/* With start space with dot.*/',
          '// Without start space without dot.',
          '// With start space with dot.',
          '/// With start space without dot.',
          '/// With start space with dot.',
          '// Ignore_for_file.',
          '// Ignore.',
          '/* With start space\n'
              'with dot.*/',
          '// Test multiline comment.',
          '// Second row.',
        ],
      );
    });

    test('reports no issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_withoutIssuePath);
      RuleTestHelper.verifyNoIssues(FormatCommentRule().check(unit));
    });
  });
}
