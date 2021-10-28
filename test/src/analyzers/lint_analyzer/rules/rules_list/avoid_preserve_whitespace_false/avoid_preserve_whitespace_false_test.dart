@TestOn('vm')
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/avoid_preserve_whitespace_false/avoid_preserve_whitespace_false.dart';
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
        startOffsets: [164],
        startLines: [6],
        startColumns: [3],
        endOffsets: [189],
        locationTexts: ['preserveWhitespace: false'],
        messages: ['Avoid using preserveWhitespace: false.'],
      );
    });
  });
}
