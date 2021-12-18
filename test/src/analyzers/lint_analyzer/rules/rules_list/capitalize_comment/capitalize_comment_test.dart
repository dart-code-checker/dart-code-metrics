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
        severity: Severity.style,
      );
    });

    test('reports about found issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = CapitalizeCommentRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startOffsets: [ 0,
          32,
          66,
          96,
          126,
          172,
          205,
          240,
          271,
          302,
          349,
          383,
          419,
          451,
          483,
          531,
          566,
          603,
          636,
          669,],
        startLines: [1,
          2,
          3,
          4,
          5,
          6,
          7,
          8,
          9,
          10,
          11,
          12,
          13,
          14,
          15,
          16,
          18,
          20,
          22,
          24,],
        startColumns: [ 1,
          1,
          1,
          1,
          1,
          1,
          1,
          1,
          1,
          1,
          1,
          1,
          1,
          1,
          1,
          1,
          1,
          1,
          1,
          1,],
        endOffsets: [31,
          65,
          95,
          125,
          171,
          204,
          239,
          270,
          301,
          348,
          382,
          418,
          450,
          482,
          530,
          565,
          602,
          635,
          668,
          717,],
        locationTexts: [
          '// With start space without dot',
          '//Without start space without dot',
          '// With start space with dot.',
          '// without capitalize letter.',
          '//with start space without capitalize letter.',
          '/// With start space without dot',
          '///Without start space without dot',
          '/// With start space with dot.',
          '/// without capitalize letter.',
          '///with start space without capitalize letter.',
          '/* With start space without dot*/',
          '/*Without start space without dot*/',
          '/* With start space with dot.*/',
          '/* without capitalize letter.*/',
          '/*with start space without capitalize letter.*/',
          '/* With start space\n'
              ' without dot*/',
          '/*Without start space\n'
              ' without dot*/',
          '/* With start space\n'
              ' with dot.*/',
          '/* without capitalize\n'
              ' letter.*/',
          '/*with start space without\n'
              ' capitalize letter.*/',
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
          '// Without capitalize letter.',
          '// With start space without capitalize letter.',
          '/// With start space without dot.',
          '/// Without start space without dot.',
          '/// With start space with dot.',
          '/// Without capitalize letter.',
          '/// With start space without capitalize letter.',
          '/* With start space without dot. */',
          '/* Without start space without dot. */',
          '/* With start space with dot. */',
          '/* Without capitalize letter. */',
          '/* With start space without capitalize letter. */',
          '/* With start space\n'
              ' without dot. */',
          '/* Without start space\n'
              ' without dot. */',
          '/* With start space\n'
              ' with dot. */',
          '/* Without capitalize\n'
              ' letter. */',
          '/* With start space without\n'
              ' capitalize letter. */',
        ],
      );
    });
  });
}
