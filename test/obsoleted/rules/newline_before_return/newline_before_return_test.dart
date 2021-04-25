@TestOn('vm')
import 'package:dart_code_metrics/src/models/severity.dart';
import 'package:dart_code_metrics/src/obsoleted/rules/newline_before_return.dart';
import 'package:test/test.dart';

import '../../../helpers/rule_test_helper.dart';

const _examplePath =
    'test/obsoleted/rules/newline_before_return/examples/example.dart';

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
        startOffsets: [177, 898, 1060],
        startLines: [12, 57, 69],
        startColumns: [5, 5, 5],
        endOffsets: [190, 911, 1073],
        locationTexts: [
          'return a + 1;',
          'return a + 2;',
          'return a + 2;',
        ],
        messages: [
          'Missing blank line before return',
          'Missing blank line before return',
          'Missing blank line before return',
        ],
      );
    });
  });
}
