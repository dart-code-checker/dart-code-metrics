@TestOn('vm')
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
        startOffsets: [0, 32, 66, 96, 129, 164, 195, 229, 265, 297],
        startLines: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
        startColumns: [1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
        endOffsets: [31, 65, 95, 128, 163, 194, 228, 264, 296, 328],
        locationTexts: [
          '// With start space without dot',
          '//Without start space without dot',
          '// with start space with dot.',
          '/// With start space without dot',
          '///Without start space without dot',
          '/// with start space with dot.',
          '/* With start space without dot*/',
          '/*Without start space without dot*/',
          '/* with start space with dot.*/',
          '/* with start space\n'
              'with dot.*/',
        ],
        messages: [
          'Prefer format comments like sentences',
          'Prefer format comments like sentences',
          'Prefer format comments like sentences',
          'Prefer format comments like sentences',
          'Prefer format comments like sentences',
          'Prefer format comments like sentences',
          'Prefer format comments like sentences',
          'Prefer format comments like sentences',
          'Prefer format comments like sentences',
          'Prefer format comments like sentences',
        ],
        replacements: [
          '// With start space without dot.',
          '// Without start space without dot.',
          '// With start space with dot.',
          '/// With start space without dot.',
          '/// Without start space without dot.',
          '/// With start space with dot.',
          '/* With start space without dot.*/',
          '/* Without start space without dot.*/',
          '/* With start space with dot.*/',
          '/* With start space\n'
              'with dot.*/',
        ],
      );
    });

    test('reports no issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_withoutIssuePath);
      RuleTestHelper.verifyNoIssues(FormatCommentRule().check(unit));
    });
  });
}
