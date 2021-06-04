@TestOn('vm')
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/models/severity.dart';
import 'package:dart_code_metrics/src/analyzers/lint_analyzer/rules/rules_list/avoid_non_null_assertion/avoid_non_null_assertion.dart';
import 'package:test/test.dart';

import '../../../../../helpers/rule_test_helper.dart';

const _examplePath = 'avoid_non_null_assertion/examples/example.dart';

void main() {
  group('AvoidNonNullAssertionRule', () {
    test('initialization', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = AvoidNonNullAssertionRule().check(unit);

      RuleTestHelper.verifyInitialization(
        issues: issues,
        ruleId: 'avoid-non-null-assertion',
        severity: Severity.warning,
      );
    });

    test('reports about found issues', () async {
      final unit = await RuleTestHelper.resolveFromFile(_examplePath);
      final issues = AvoidNonNullAssertionRule().check(unit);

      RuleTestHelper.verifyIssues(
        issues: issues,
        startOffsets: [70, 208, 208, 460],
        startLines: [7, 15, 15, 27],
        startColumns: [5, 5, 5, 5],
        endOffsets: [76, 215, 222, 467],
        locationTexts: [
          'field!',
          'object!',
          'object!.field!',
          'object!',
        ],
        messages: [
          'Avoid using non null assertion.',
          'Avoid using non null assertion.',
          'Avoid using non null assertion.',
          'Avoid using non null assertion.',
        ],
      );
    });
  });
}
