import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/avoid_preserve_whitespace_false/avoid_preserve_whitespace_false_rule.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'avoid_preserve_whitespace_false/examples/example.dart';

void main() {
  group('AvoidPreserveWhitespaceFalseRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = AvoidPreserveWhitespaceFalseRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'avoid-preserve-whitespace-false',
        severity: Severity.warning,
      );
    });

    test('reports about found issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = AvoidPreserveWhitespaceFalseRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startLines: [6],
        startColumns: [3],
        locationTexts: ['preserveWhitespace: false'],
        messages: ['Avoid using preserveWhitespace: false.'],
      );
    });
  });
}
