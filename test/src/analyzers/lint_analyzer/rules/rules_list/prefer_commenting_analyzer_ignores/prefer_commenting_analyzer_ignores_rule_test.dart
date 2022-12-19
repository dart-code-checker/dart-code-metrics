import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/prefer_commenting_analyzer_ignores/prefer_commenting_analyzer_ignores.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'prefer_commenting_analyzer_ignores/examples/example.dart';

void main() {
  group('PreferCommentingAnalyzerIgnores', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = PreferCommentingAnalyzerIgnores().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'prefer-commenting-analyzer-ignores',
        severity: Severity.warning,
      );
    });

    test('reports about found issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = PreferCommentingAnalyzerIgnores().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [3, 6, 23],
        startColumns: [3, 3, 3],
        locationTexts: [
          '// ignore: deprecated_member_use',
          '// ignore: deprecated_member_use, long-method',
          '// ignore: avoid-non-null-assertion',
        ],
        messages: [
          'Prefer commenting analyzer ignores.',
          'Prefer commenting analyzer ignores.',
          'Prefer commenting analyzer ignores.',
        ],
      );
    });
  });
}
