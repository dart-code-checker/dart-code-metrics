@TestOn('vm')
import 'package:dart_code_metrics/src/models/severity.dart';
import 'package:dart_code_metrics/src/rules/newline_before_return/newline_before_return.dart';
import 'package:test/test.dart';

import '../helpers/file_resolver.dart';
import '../helpers/rule_test_helper.dart';

const _examplePath = 'test/resources/newline_before_return_example.dart';

void main() {
  group('NewlineBeforeReturnRule', () {
    test('initialization', () async {
      final unit = await FileResolver.resolve(_examplePath);
      final issues = NewlineBeforeReturnRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'newline-before-return',
        severity: Severity.style,
      );
    });

    test('reports about found issues', () async {
      final unit = await FileResolver.resolve(_examplePath);
      final issues = NewlineBeforeReturnRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startOffsets: [256, 977, 1139],
        startLines: [13, 58, 70],
        startColumns: [5, 5, 5],
        endOffsets: [269, 990, 1152],
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
