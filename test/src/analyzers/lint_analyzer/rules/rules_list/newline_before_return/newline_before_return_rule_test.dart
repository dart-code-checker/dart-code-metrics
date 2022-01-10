import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/newline_before_return/newline_before_return_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'newline_before_return/examples/example.dart';

void main() {
  group('NewlineBeforeReturnRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = NewlineBeforeReturnRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'newline-before-return',
        severity: Severity.style,
      );
    });

    test('reports about found issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = NewlineBeforeReturnRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [13, 58, 70],
        startColumns: [5, 5, 5],
        locationTexts: [
          'return a + 1;',
          'return a + 2;',
          'return a + 2;',
        ],
        messages: [
          'Missing blank line before return.',
          'Missing blank line before return.',
          'Missing blank line before return.',
        ],
      );
    });
  });
}
